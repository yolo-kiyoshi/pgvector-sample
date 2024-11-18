
# PostgreSQL + pgvector with Docker Compose

This repository provides a simple setup for trying out PostgreSQL with the `pgvector` extension using Docker Compose. It enables easy initialization, including activating the `pgvector` extension and creating a sample database.

## Features

- **Quick Setup**: Run `docker-compose up -d` to start a PostgreSQL container.
- **Persistent Data**: Data is stored persistently in the `postgres/pgdata` directory.
- **Automatic Initialization**: The `postgres/init.sql` file is used for enabling the `pgvector` extension and creating a sample database. This file is automatically executed during the container's initialization.

## How to Use

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Start the container:
   ```bash
   docker-compose up -d
   ```

3. Access the PostgreSQL database:
   ```bash
   psql -h localhost -U postgres
   ```

   The default username and password are both set to `postgres`. You can modify these in the `docker-compose.yml` file under the `environment` section.

## Directory Structure

- `docker-compose.yml`: Configures the PostgreSQL container and its environment.
- `Dockerfile`: Builds a custom PostgreSQL image with the `pgvector` extension.
- `postgres/init.sql`: Contains SQL scripts for initializing the database (e.g., enabling `pgvector` and creating sample tables).
- `postgres/pgdata`: Directory for storing persistent database files.

## Example Configuration

### docker-compose.yml
```yaml
version: "3.9"
services:
  postgres:
    build:
      context: .
    ports:
      - "5432:5432"
    volumes:
      - ./postgres:/var/lib/postgresql/data
      - ./postgres/init:/docker-entrypoint-initdb.d
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - PGDATA=/var/lib/postgresql/data/pgdata
```

### Dockerfile
```dockerfile
FROM --platform=arm64 postgres:17.1

RUN apt-get update && \
    apt-get install -y git make gcc postgresql-server-dev-17

RUN cd /tmp && \
    git clone --branch v0.5.1 https://github.com/pgvector/pgvector.git && \
    cd pgvector && \
    make && \
    make install && \
    cd ../ && rm -rf pgvector
```

### Sample Initialization Script (postgres/init.sql)
```sql
/*
init
*/
DROP DATABASE IF EXISTS sample_vector_db;
CREATE DATABASE sample_vector_db;
-- connect the created vectore db
\c sample_vector_db;
-- create extension
DROP EXTENSION IF EXISTS vector;
CREATE EXTENSION vector;
-- create table
-- ref: https://github.com/pgvector/pgvector
DROP TABLE IF EXISTS items;
CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3));
-- insert vectors
INSERT INTO items (embedding) VALUES ('[1,2,3]'), ('[4,5,6]');

```

## Notes

- Make sure to adjust permissions for the `postgres/pgdata` directory if needed:
  ```bash
  chmod -R 777 postgres/pgdata
  ```

- For ARM-based systems like M1/M2 MacBooks, this setup uses the `--platform=arm64` option in the Dockerfile.

## License

This project is open-source and available under the MIT License. Contributions are welcome!
