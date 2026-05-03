# Investigación: Liquibase y Control de Cambios en Base de Datos

## 1. ¿Qué es Liquibase?

Liquibase es una herramienta de código abierto para el **control de versiones de bases de datos**.
Permite gestionar, rastrear y aplicar cambios en el esquema de una base de datos de manera
ordenada, reproducible y colaborativa — de la misma forma que Git controla versiones de código fuente.

**¿Por qué es importante?**
Sin Liquibase (o herramientas similares), los cambios a la base de datos se hacen manualmente y
es difícil saber qué cambios se aplicaron, en qué orden y quién los hizo. Liquibase resuelve
este problema registrando cada cambio como una unidad versionada llamada *changeset*.

---

## 2. Conceptos Clave

### Changelog
Archivo (XML, YAML, JSON o SQL) que actúa como **historial de cambios** de la base de datos.
Contiene todos los changesets en el orden en que deben ejecutarse.

En este proyecto el archivo principal es:
```
db/changelog/db.changelog-master.yaml
```
Este archivo orquesta (incluye) los changelogs de DDL y de DML por separado.

### Changeset
La **unidad mínima de cambio** en Liquibase. Cada changeset tiene:
- `id`: identificador único dentro del archivo
- `author`: quién realizó el cambio
- Instrucción SQL (CREATE TABLE, INSERT, ALTER TABLE, etc.)
- Bloque `rollback`: instrucción para deshacer el cambio

Ejemplo en SQL formateado para Liquibase:
```sql
-- liquibase formatted sql

-- changeset estudiante:DDL-001-crear-persona
CREATE TABLE persona (
    id_persona SERIAL PRIMARY KEY,
    nombre     VARCHAR(100) NOT NULL
);

-- rollback DROP TABLE IF EXISTS persona;
```

Liquibase registra cada changeset ejecutado en la tabla `databasechangelog` para no volver
a ejecutarlo en futuros despliegues.

### Rollback
Mecanismo para **deshacer** uno o más changesets previamente aplicados.
Cada changeset puede tener un bloque `rollback` que especifica cómo revertir el cambio.

Comando para hacer rollback del último changeset:
```bash
docker compose run --rm liquibase rollbackCount 1
```

---

## 3. DDL vs DML

| Categoría | Significado                        | Ejemplos                               |
|-----------|------------------------------------|----------------------------------------|
| **DDL**   | Data Definition Language           | `CREATE TABLE`, `ALTER TABLE`, `DROP`  |
| **DML**   | Data Manipulation Language         | `INSERT`, `UPDATE`, `DELETE`           |

**¿Por qué separarlos?**
- El DDL define la **estructura** (esquema); debe ejecutarse primero.
- El DML manipula los **datos**; depende de que la estructura ya exista.
- La separación facilita el mantenimiento, la legibilidad y la aplicación selectiva de cambios.

En este proyecto:
- `db/changelog/ddl/` → contiene los CREATE TABLE (estructura de las 6 tablas)
- `db/changelog/dml/` → contiene los INSERT, UPDATE y DELETE de prueba

---

## 4. Docker Compose y Contenedores

**Docker** es una plataforma que permite empaquetar aplicaciones en **contenedores**: entornos
aislados y reproducibles que incluyen todo lo necesario para ejecutar el software.

**Docker Compose** es una herramienta para definir y ejecutar múltiples contenedores como
un único servicio, mediante un archivo `docker-compose.yml`.

En este proyecto se definen dos servicios:
- `db`: contenedor con PostgreSQL 15 (motor de base de datos)
- `liquibase`: contenedor que ejecuta las migraciones al iniciarse

**Ventaja de reproducibilidad**: cualquier persona que clone el repositorio puede ejecutar
`docker compose up` y obtener exactamente el mismo entorno, sin instalar PostgreSQL ni
Liquibase manualmente.

---

## 5. Flujo de Ejecución

```
git clone → docker compose up -d db → docker compose run liquibase update
                    ↓                              ↓
          Levanta PostgreSQL               Aplica DDL (6 tablas)
          con base mgbd_liquibase          Aplica DML (datos prueba)
                                           Registra en databasechangelog
```

---

## 6. Tablas de Control de Liquibase

Liquibase crea automáticamente dos tablas en la base de datos:

| Tabla                    | Propósito                                                  |
|--------------------------|------------------------------------------------------------|
| `databasechangelog`      | Historial de todos los changesets aplicados                |
| `databasechangeloglock`  | Evita que dos instancias de Liquibase corran simultáneamente |

---

## 7. Comandos Principales

| Comando                        | Descripción                                          |
|-------------------------------|------------------------------------------------------|
| `liquibase update`            | Aplica todos los changesets pendientes               |
| `liquibase validate`          | Verifica que el changelog no tiene errores de sintaxis |
| `liquibase status --verbose`  | Muestra qué changesets están pendientes de aplicar   |
| `liquibase rollbackCount N`   | Deshace los últimos N changesets                     |
| `liquibase history`           | Muestra el historial de changesets aplicados         |

---

## 8. Buenas Prácticas

1. **Nunca modificar un changeset ya aplicado** — Liquibase detecta el cambio por checksum y falla.
2. **Siempre incluir rollback** — facilita revertir en entornos de producción.
3. **IDs descriptivos** — facilitan la trazabilidad (`DDL-001-crear-persona` es mejor que `1`).
4. **Separar DDL y DML** — mejora la organización y permite aplicar solo estructura sin datos.
5. **Versionar con Git** — los changelogs son código y deben estar bajo control de versiones.
