import datetime as dt
import psycopg
import random
import time
import uuid
from faker import Faker

class Clientes:
    def __init__(self, args: dict):
        # args is a dict of string passed with the --args flag
        # user passed a yaml/json, in python that's a dict object

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
        return [self.insert_cliente]

    def insert_cliente(self, conn: psycopg.Connection):
        with conn.cursor() as cur:

            self.cliente = self.fake.name()
            self.nit = self.fake.ssn()
            self.telefono = self.fake.phone_number()
            self.direccion = self.fake.address().replace("\n", "")

            stmt = """
                insert into ach.clientes (cliente_uuid, cliente, cliente_nit, cliente_telefono, cliente_direccion, cliente_actualizacion) 
                values (gen_random_uuid(), %s, unique_rowid(), %s, %s, now());
                """
            cur.execute(stmt, (self.cliente, self.telefono, self.direccion))
