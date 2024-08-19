#!/bin/bash

while true; do

    echo "Estado 4"
    start=`date +%s.%N`
    cockroach sql --host=172.31.14.254:26257 --insecure --execute "BEGIN; INSERT INTO ach.log_movimientos (movimiento_uuid, log_movimiento_detalle, log_movimiento_fecha) SELECT movimiento_uuid, 'Cambio de estado: 4 a 5' AS log_movimiento_detalle, now() AS log_movimiento_fecha FROM ach.movimientos WHERE movimiento_estado = 4; UPDATE ach.movimientos SET movimiento_estado = 5, movimiento_ultima_actualizacion = now() WHERE movimiento_estado = 4; UPDATE ach.movimientos SET ind_fraude = 1 FROM ach.fraude WHERE ach.movimientos.movimiento_uuid = ach.fraude.movimiento_uuid AND ach.movimientos.movimiento_estado = 0; UPDATE ach.movimientos SET ind_fraude = 1 FROM ach.fraude WHERE ach.movimientos.movimiento_uuid = ach.fraude.movimiento_uuid AND ach.movimientos.movimiento_estado = 0;;COMMIT;"
    end=`date +%s`
    end=`date +%s.%N`
    runtime=$( echo "$end - $start" | bc -l )
    echo $runtime

    echo "Estado 3"
    start=`date +%s.%N`
    cockroach sql --host=172.31.14.254:26257 --insecure --execute "BEGIN; INSERT INTO ach.log_movimientos (movimiento_uuid, log_movimiento_detalle, log_movimiento_fecha) SELECT movimiento_uuid, 'Cambio de estado: 3 a 4' AS log_movimiento_detalle, now() AS log_movimiento_fecha FROM ach.movimientos WHERE movimiento_estado = 3; UPDATE ach.movimientos SET movimiento_estado = 4, movimiento_ultima_actualizacion = now() WHERE movimiento_estado = 3; COMMIT;"
    end=`date +%s.%N`
    runtime=$( echo "$end - $start" | bc -l )
    echo $runtime

    echo "Estado 2"
    start=`date +%s.%N`
    cockroach sql --host=172.31.14.254:26257 --insecure --execute "BEGIN; INSERT INTO ach.log_movimientos (movimiento_uuid, log_movimiento_detalle, log_movimiento_fecha) SELECT movimiento_uuid, 'Cambio de estado: 2 a 3' AS log_movimiento_detalle, now() AS log_movimiento_fecha FROM ach.movimientos WHERE movimiento_estado = 2; UPDATE ach.movimientos SET movimiento_estado = 3, movimiento_ultima_actualizacion = now() WHERE movimiento_estado = 2; COMMIT;"
    end=`date +%s.%N`
    runtime=$( echo "$end - $start" | bc -l )
    echo $runtime

    echo "Estado 1"
    start=`date +%s.%N`
    cockroach sql --host=172.31.14.254:26257 --insecure --execute "BEGIN; INSERT INTO ach.log_movimientos (movimiento_uuid, log_movimiento_detalle, log_movimiento_fecha) SELECT movimiento_uuid, 'Cambio de estado: 1 a 2' AS log_movimiento_detalle, now() AS log_movimiento_fecha FROM ach.movimientos WHERE movimiento_estado = 1; UPDATE ach.movimientos SET movimiento_estado = 2, movimiento_ultima_actualizacion = now() WHERE movimiento_estado = 1; COMMIT;"
    end=`date +%s.%N`
    runtime=$( echo "$end - $start" | bc -l )
    echo $runtime

    echo "Estado 0"
    start=`date +%s.%N`
    cockroach sql --host=172.31.14.254:26257 --insecure --execute "BEGIN; INSERT INTO ach.log_movimientos (movimiento_uuid, log_movimiento_detalle, log_movimiento_fecha) SELECT movimiento_uuid, 'Cambio de estado: 0 a 1' AS log_movimiento_detalle, now() AS log_movimiento_fecha FROM ach.movimientos WHERE movimiento_estado = 0 LIMIT 3000; UPDATE ach.movimientos SET movimiento_estado = 1, movimiento_ultima_actualizacion = now() WHERE movimiento_estado = 0 AND movimiento_fecha_creacion < NOW(); COMMIT;"
    end=`date +%s.%N`
    runtime=$( echo "$end - $start" | bc )
    echo $runtime

done
