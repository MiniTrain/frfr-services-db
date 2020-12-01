FROM postgres:11.7-alpine
COPY init-db/schema.sql /docker-entrypoint-initdb.d/001_schema.sql
COPY init-db/data.sql /docker-entrypoint-initdb.d/002_data.sql
COPY init-db/users.sql /docker-entrypoint-initdb.d/003_users.sql
ENV PGDATA=/data