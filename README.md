# query_in_all_dbs.sh

## Description

This script is designed to execute SQL queries across multiple Oracle databases simultaneously or individually. It also allows for database management, such as starting up or shutting down databases as needed.

## Features

- **SQL Query Execution:**
  - Example: `SELECT * FROM ABENZANT.LISTA;`
  - Example: `CREATE TABLE ABENZANT.LISTA(lista VARCHAR(50));`
- **Database Management:**
  - Command: `startup;`
  - Command: `shutdown immediate;`
- Supports selecting specific instances or applying changes to all instances.

## Caution

⚠️ This script directly modifies databases. Use it carefully in production environments.

## System Requirements

- **Oracle Database 19c** (default path: `/u01/app/oracle/product/19c/db`).
- Environment variables:
  - `ORACLE_BASE` should point to `/u01/app/oracle`.
  - `ORACLE_HOME` should point to `/u01/app/oracle/product/19c/db`.

## Usage

### Basic Execution
1. Download the script and grant execution permissions:
   ```bash
   chmod +x query_in_all_dbs.sh
   ```
2. Run it:
   ```bash
   ./query_in_all_dbs.sh
   ```

### Main Menu
The script provides the following options:

1. **Execute a query in all instances:** Applies an SQL query to all available databases.
2. **Select specific instances:** Allows you to choose one or more instances to run the query.
3. **Exit:** Ends the script execution.

### Query Examples
- Basic query:
  ```
  SELECT * FROM ABENZANT.LISTA;
  ```
- Create a table:
  ```
  CREATE TABLE ABENZANT.LISTA(lista VARCHAR(50));
  ```
- Start all databases:
  ```
  startup;
  ```
- Shut down databases:
  ```
  shutdown immediate;
  ```

## Included Validations
- **Empty Query:** The script ensures that the SQL query is not empty before execution.
- **Instance Selection:** Validates that at least one instance is specified when selecting specific databases.

## Warnings
- **Direct Modifications:** This script interacts directly with critical databases, which may affect their availability.

## Author
**Alengi Benzant**  
Created on November 28, 2024.
