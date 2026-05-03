# task-mgbd-liquibase

Base de datos relacional construida con **Liquibase** sobre **PostgreSQL**, usando
separación de migraciones DDL y DML, control de versiones y ejecución reproducible
con contenedores Docker.

---

## Estructura del Repositorio

```
task-mgbd-liquibase/
├── README.md                                  ← Este archivo
├── docker-compose.yml                         ← Levanta PostgreSQL + Liquibase
├── liquibase.properties                       ← Configuración de conexión (uso local)
├── db/
│   ├── changelog/
│   │   ├── db.changelog-master.yaml           ← Orquesta todos los changelogs
│   │   ├── ddl/                               ← DDL: Creación de tablas
│   │   │   ├── 001-create-persona.sql
│   │   │   ├── 002-create-rol.sql
│   │   │   ├── 003-create-usuario.sql
│   │   │   ├── 004-create-producto.sql
│   │   │   ├── 005-create-factura.sql
│   │   │   └── 006-create-detalle-factura.sql
│   │   └── dml/                               ← DML: Datos y operaciones
│   │       ├── 001-insert-data.sql
│   │       ├── 002-update-data.sql
│   │       └── 003-delete-data.sql
│   └── scripts/
│       └── queries/                           ← Consultas de validación
│           ├── 001-select-personas.sql
│           ├── 002-select-facturas.sql
│           └── 003-select-detalle-factura.sql
└── docs/
    ├── investigacion-liquibase.md             ← Investigación conceptual
    └── evidencias.md                          ← Evidencias de ejecución
```

---

## Modelo Relacional

Las seis tablas autorizadas y sus relaciones mediante llaves foráneas:

```
persona ──────────── usuario ──────────── rol
                        │
                        │ (comprador)
                        ▼
                     factura
                        │
                        ▼
                 detalle_factura ───── producto
```

| Tabla             | Descripción                                        |
|-------------------|----------------------------------------------------|
| `persona`         | Datos personales de cada individuo                 |
| `rol`             | Roles del sistema (administrador, vendedor, cliente)|
| `usuario`         | Acceso al sistema; referencia a `persona` y `rol`  |
| `producto`        | Catálogo de productos con precio y stock           |
| `factura`         | Registro de cada venta; referencia a `usuario`     |
| `detalle_factura` | Líneas de cada factura; referencia a `factura` y `producto` |

---

## Requisitos Previos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y ejecutándose.

No se requiere instalar PostgreSQL ni Liquibase de forma manual.

---

## Cómo Levantar el Contenedor y Ejecutar las Migraciones

### 1. Clonar el repositorio

```bash
git clone https://github.com/<tu-usuario>/task-mgbd-liquibase.git
cd task-mgbd-liquibase
```

### 2. Limpiar entorno previo (si ya se ejecutó antes)

```bash
docker compose down -v
```

### 3. Levantar PostgreSQL

```bash
docker compose up -d db
```

Espera unos segundos a que el contenedor esté saludable (healthcheck automático).

### 4. Validar el changelog (verificar sintaxis)

```bash
docker compose run --rm liquibase validate
```

Salida esperada: `Liquibase command 'validate' was executed successfully.`

### 5. Aplicar las migraciones

```bash
docker compose run --rm liquibase update
```

Este comando aplica en orden:
- Los 6 changelogs DDL (crea las tablas)
- Los 3 changelogs DML (inserta, actualiza y elimina datos de prueba)

Salida esperada: `Liquibase command 'update' was executed successfully.`

### 6. Verificar el estado

```bash
docker compose run --rm liquibase status --verbose
```

Salida esperada: `All changesets have been executed.`

---

## Validar la Base de Datos en PostgreSQL

```bash
# Ver todas las tablas creadas
docker compose exec db psql -U postgres -d mgbd_liquibase -c "\dt"

# Consultar la tabla persona
docker compose exec db psql -U postgres -d mgbd_liquibase -c "SELECT * FROM persona;"

# Consultar la tabla factura
docker compose exec db psql -U postgres -d mgbd_liquibase -c "SELECT * FROM factura;"
```

---

## Ejecutar las Consultas de Validación

```bash
# Personas con su usuario y rol
docker compose exec db psql -U postgres -d mgbd_liquibase \
  -f /dev/stdin < db/scripts/queries/001-select-personas.sql

# Facturas con nombre del cliente
docker compose exec db psql -U postgres -d mgbd_liquibase \
  -f /dev/stdin < db/scripts/queries/002-select-facturas.sql

# Detalle completo de facturas
docker compose exec db psql -U postgres -d mgbd_liquibase \
  -f /dev/stdin < db/scripts/queries/003-select-detalle-factura.sql
```

---

## Rollback (deshacer migraciones)

```bash
# Deshacer el último changeset
docker compose run --rm liquibase rollbackCount 1

# Ver historial de migraciones aplicadas
docker compose run --rm liquibase history
```

---

## Datos de Conexión

| Parámetro    | Valor            |
|--------------|------------------|
| Host         | localhost        |
| Puerto       | 5432             |
| Base de datos| mgbd_liquibase   |
| Usuario      | postgres         |
| Contraseña   | postgres123      |

Compatible con DBeaver, pgAdmin, TablePlus y cualquier cliente PostgreSQL.

---

## Documentación Adicional

- [`docs/investigacion-liquibase.md`](docs/investigacion-liquibase.md) — Conceptos de Liquibase, changelog, changeset, rollback, DDL/DML y Docker Compose.
- [`docs/evidencias.md`](docs/evidencias.md) — Comandos usados y salida esperada en cada paso.
