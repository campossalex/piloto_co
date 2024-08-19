import datetime as dt
import psycopg
import random
import time
import uuid
from faker import Faker

class Entidades:
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
        return [self.insert_entidad]

    # conn is an instance of a psycopg connection object
    # conn is set by default with autocommit=True, so no need to send a commit message
    def insert_entidad(self, conn: psycopg.Connection):
        with conn.cursor() as cur:

            self.entidad = self.fake.name()
            self.email = self.fake.email()
            self.telefono = self.fake.phone_number()
            self.direccion = self.fake.address().replace("\n", "")

            stmt = """
                insert into ach.entidades (entidad_uuid, entidad, entidad_nit, entidad_correo, entidad_telefono, entidad_direccion, entidad_actualizacion) 
                values (gen_random_uuid(), %s, unique_rowid(), %s, %s, %s, now());
                """
            cur.execute(stmt, (self.entidad, self.email, self.telefono, self.direccion))
