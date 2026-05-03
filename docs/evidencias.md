# Evidencias de Ejecución

## Entorno Usado

| Componente  | Versión         |
|-------------|-----------------|
| Docker      | 24.x o superior |
| PostgreSQL  | 15-alpine       |
| Liquibase   | 4.27            |
| Sistema Op. | Windows 11 / macOS / Linux |

---

## Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/<tu-usuario>/task-mgbd-liquibase.git
cd task-mgbd-liquibase
```

**Salida esperada:**
```
Cloning into 'task-mgbd-liquibase'...
remote: Enumerating objects: ...
Receiving objects: 100% ...
```

---

## Paso 2: Limpiar entorno previo (si existe)

```bash
docker compose down -v
```

**Salida esperada:**
```
[+] Running 3/3
 ✔ Container mgbd_liquibase_runner  Removed
 ✔ Container mgbd_liquibase_db      Removed
 ✔ Volume task-mgbd-liquibase_postgres_data  Removed
```

---

## Paso 3: Levantar PostgreSQL

```bash
docker compose up -d db
```

**Salida esperada:**
```
[+] Running 2/2
 ✔ Network task-mgbd-liquibase_default  Created
 ✔ Container mgbd_liquibase_db          Started
```

---

## Paso 4: Validar el changelog

```bash
docker compose run --rm liquibase validate
```

**Salida esperada:**
```
####################################################
##   _     _             _ _                      ##
##  | |   (_)           (_) |                     ##
##  | |    _  __ _ _   _ _| |__   __ _ ___  ___  ##
##  | |   | |/ _` | | | | | '_ \ / _` / __|/ _ \ ##
##  | |___| | (_| | |_| | | |_) | (_| \__ \  __/ ##
##  \_____/_|\__, |\__,_|_|_.__/ \__,_|___/\___| ##
##              | |                               ##
##              |_|                               ##
##                                                ##
##  Get documentation at docs.liquibase.com       ##
####################################################

Liquibase Version: 4.27.0
...
No validation errors found.
Liquibase command 'validate' was executed successfully.
```

---

## Paso 5: Aplicar las migraciones

```bash
docker compose run --rm liquibase update
```

**Salida esperada:**
```
Running Changeset: db/changelog/ddl/001-create-persona.sql::DDL-001-crear-persona::estudiante
Running Changeset: db/changelog/ddl/002-create-rol.sql::DDL-002-crear-rol::estudiante
Running Changeset: db/changelog/ddl/003-create-usuario.sql::DDL-003-crear-usuario::estudiante
Running Changeset: db/changelog/ddl/004-create-producto.sql::DDL-004-crear-producto::estudiante
Running Changeset: db/changelog/ddl/005-create-factura.sql::DDL-005-crear-factura::estudiante
Running Changeset: db/changelog/ddl/006-create-detalle-factura.sql::DDL-006-crear-detalle-factura::estudiante
Running Changeset: db/changelog/dml/001-insert-data.sql::DML-001-insertar-datos::estudiante
Running Changeset: db/changelog/dml/002-update-data.sql::DML-002-actualizar-datos::estudiante
Running Changeset: db/changelog/dml/003-delete-data.sql::DML-003-eliminar-datos::estudiante

Liquibase command 'update' was executed successfully.
```

---

## Paso 6: Verificar estado

```bash
docker compose run --rm liquibase status --verbose
```

**Salida esperada:**
```
All changesets have been executed.
Liquibase command 'status' was executed successfully.
```

---

## Paso 7: Validación en PostgreSQL

```bash
# Ver todas las tablas creadas
docker compose exec db psql -U postgres -d mgbd_liquibase -c "\dt"
```

**Salida esperada:**
```
              List of relations
 Schema |       Name       | Type  |  Owner
--------+------------------+-------+----------
 public | databasechangelog| table | postgres
 public | databasechangeloglock | table | postgres
 public | detalle_factura  | table | postgres
 public | factura          | table | postgres
 public | persona          | table | postgres
 public | producto         | table | postgres
 public | rol              | table | postgres
 public | usuario          | table | postgres
(8 rows)
```

```bash
# Verificar datos en persona
docker compose exec db psql -U postgres -d mgbd_liquibase -c "SELECT * FROM persona;"
```

**Salida esperada:**
```
 id_persona | nombre |  apellido  |            correo             |  telefono  | fecha_nacimiento
------------+--------+------------+-------------------------------+------------+-----------------
          1 | Carlos | Pérez      | carlos.perez@ejemplo.com      | 3001234567 | 1990-05-15
          2 | Ana    | García     | ana.garcia@ejemplo.com        | 3001112233 | 1995-08-22
          3 | Luis   | Martínez   | luis.martinez@ejemplo.com     | 3209876543 | 1988-11-30
(3 rows)
```

```bash
# Verificar datos en factura
docker compose exec db psql -U postgres -d mgbd_liquibase -c "SELECT * FROM factura;"
```

**Salida esperada:**
```
 id_factura |       fecha_emision        |   total    |  estado   | id_usuario
------------+----------------------------+------------+-----------+------------
          1 | 2026-05-03 10:00:00.000000 | 2585000.00 | entregada |          3
(1 row)
```

---

## Comandos de Rollback (opcional)

```bash
# Deshacer el último changeset aplicado
docker compose run --rm liquibase rollbackCount 1

# Ver historial completo de migraciones
docker compose run --rm liquibase history
```

---

> **Nota:** Las capturas de pantalla reales se agregarán durante la ejecución del proyecto
> en el entorno local del estudiante, si el profesor las solicita.
