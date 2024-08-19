import psycopg
import random
import time
import uuid
import random
from faker import Faker

class Movimientos:
    def __init__(self, args: dict):
        # args is a dict of string passed with the --args flag
        # user passed a yaml/json, in python that's a dict object
        Faker.seed(random.randint(155, 389))
        self.fake = Faker()

    # the setup() function is executed only once
    # when a new executing thread is started.
    # Also, the function is a vector to receive the excuting threads's unique id and the total thread count
    def setup(self, conn: psycopg.Connection, id: int, total_thread_count: int):
        with conn.cursor() as cur:
            print(
                f"My thread ID is {id}. The total count of threads is {total_thread_count}"
            )

    # the run() function returns a list of functions
    # that dbworkload will execute, sequentially.
    # Once every func has been executed, run() is re-evaluated.
    # This process continues until dbworkload exits.
    def loop(self):
        return [self.insert_movimiento]

    # conn is an instance of a psycopg connection object
    # conn is set by default with autocommit=True, so no need to send a commit message
    def insert_movimiento(self, conn: psycopg.Connection):
        with conn.cursor() as cur:

            self.valor = self.fake.pydecimal(6, 2, positive=True, min_value=400000, max_value=1000000)

            cur.execute("SELECT * FROM ach.clientes order by cliente_actualizacion desc LIMIT 1")
            cliente = cur.fetchone()

            cur.execute("SELECT * FROM ach.entidades ORDER BY random() LIMIT 1")
            entidad_origen = cur.fetchone()

            cur.execute("SELECT * FROM ach.entidades ORDER BY random() LIMIT 1")
            entidad_destino = cur.fetchone()

            stmt = """
                insert into ach.movimientos (movimiento_uuid, cliente_id, entidad_origen_id, entidad_destino_id, movimiento_valor, movimiento_fecha_creacion)
                values (gen_random_uuid(), %s, %s, %s, %s, now()) RETURNING CAST(movimiento_uuid AS STRING);
                """
            cur.execute(stmt, (cliente[0], entidad_origen[0], entidad_destino[0], self.valor))

            if self.valor > 500000:
                new_row_id = cur.fetchone()
                stmt = """
                    insert into ach.fraude (fraude_uuid, movimiento_uuid, cliente_id, entidad_origen_id, fraude_valor, fraude_fecha)
                    values (gen_random_uuid(), %s, %s, %s, %s, now());
                    """
                cur.execute(stmt, (new_row_id[0], cliente[0], entidad_origen[0], self.valor))
