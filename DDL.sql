/* Tabla entidades */
DROP TABLE default.entidades;

CREATE TABLE default.entidades (
      entidad_uuid UUID DEFAULT gen_random_uuid(),
      entidad STRING,
      entidad_nit STRING,
      entidad_correo STRING,
      entidad_telefono STRING,
      entidad_direccion STRING,
      entidad_actualizacion TIMESTAMP,
      PRIMARY KEY (entidad_uuid)
  );

CREATE INDEX on default.entidades (entidad_actualizacion);

/* Tabla clientes */
DROP TABLE default.clientes;

CREATE TABLE default.clientes (
      cliente_uuid UUID DEFAULT gen_random_uuid(),
      cliente STRING,
      cliente_nit STRING,
      cliente_telefono STRING,
      cliente_direccion STRING,
      cliente_actualizacion TIMESTAMP,
      FAMILY f_pka (cliente_uuid),
      FAMILY f_info_basica (cliente, cliente_nit, cliente_telefono, cliente_direccion),
      PRIMARY KEY (cliente_uuid)
  );

CREATE INDEX on default.clientes (cliente_actualizacion);

/* Tabla movimientos */
DROP TABLE default.movimientos cascade;

CREATE TABLE default.movimientos (
      movimiento_uuid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      cliente_id UUID NOT NULL REFERENCES clientes (cliente_uuid) ON UPDATE CASCADE ON DELETE CASCADE,
      entidad_origen_id UUID NOT NULL REFERENCES entidades (entidad_uuid) ON UPDATE CASCADE ON DELETE CASCADE,
      entidad_destino_id UUID NOT NULL REFERENCES entidades (entidad_uuid) ON UPDATE CASCADE ON DELETE CASCADE,
      movimiento_valor DECIMAL(10, 2),
      movimiento_fecha_creacion TIMESTAMP,
      movimiento_estado INT DEFAULT 0,
      movimiento_ultima_actualizacion TIMESTAMP,
      consolidado_id INT DEFAULT 0,
      consolidado_fecha TIMESTAMP DEFAULT NULL,
      ind_fraude INT DEFAULT 0,
      FAMILY f_info_basica (movimiento_uuid, cliente_id, entidad_origen_id, entidad_destino_id, movimiento_valor, movimiento_fecha_creacion),
      FAMILY f_estado (movimiento_estado, movimiento_ultima_actualizacion),
      FAMILY f_consolidado (consolidado_id, consolidado_fecha)
  );

CREATE INDEX ON default.movimientos (movimiento_estado) USING HASH WITH (bucket_count = 6);

/* Tabla log_movimientos */
DROP TABLE default.log_movimientos cascade;

CREATE TABLE default.log_movimientos (
      log_movimiento_uuid UUID NOT NULL DEFAULT gen_random_uuid(),
      movimiento_uuid UUID NOT NULL REFERENCES default.movimientos (movimiento_uuid) ON UPDATE CASCADE ON DELETE CASCADE,
      log_movimiento_detalle STRING,
      log_movimiento_fecha TIMESTAMP
  );

/* Tabla fraude */
DROP TABLE default.fraude cascade;

CREATE TABLE default.fraude (
      fraude_uuid UUID NOT NULL DEFAULT gen_random_uuid(),
      movimiento_uuid UUID NOT NULL REFERENCES default.movimientos (movimiento_uuid) ON UPDATE CASCADE ON DELETE CASCADE,
      cliente_id UUID NOT NULL REFERENCES clientes (cliente_uuid) ON UPDATE CASCADE ON DELETE CASCADE,
      entidad_origen_id UUID NOT NULL REFERENCES entidades (entidad_uuid) ON UPDATE CASCADE ON DELETE CASCADE,
      fraude_valor DECIMAL(10, 2),
      fraude_fecha TIMESTAMP
  );


CREATE INDEX on default.fraude (movimiento_uuid) STORING (cliente_id, entidad_origen_id, fraude_valor);
