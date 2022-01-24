# SQL Server Debezium Kafka ElasticSearch
Nowadays, every RDBMS database is coming with CDC(Change Data Capture support) we can leverage these and create a data pipeline to fetch the real-time changes in the databases.We can set up a simple streaming pipeline to ingest CDC events from SQL Server to Kafka using Debezium and Kafka Connect, and the Confluent Elasticsearch connector is continuously reading those same topics and writing the events into Elasticsearch.
## Topology
Here’s a diagram that shows how the data is flowing through our distributed system. First, the Debezium SQL Server connector is continuously capturing the changes from the SQL Server database, and sending the changes for each table to separate Kafka topics. Then, the Confluent JDBC sink connector is continuously reading those topics  and the Confluent Elasticsearch connector is continuously reading those same topics and writing the events into Elasticsearch.

![Alt text](/assert/images/topology.png?raw=true "Title")

### Debezium Architecture

![Alt text](/assert/images/architecture.png?raw=true "Title")

https://debezium.io/documentation/reference/stable/architecture.html
## Kafka Connect Elasticsearch Connector
The kafka-connect-elasticsearch is a Kafka Connector for copying data between Kafka and Elasticsearch.

https://github.com/confluentinc/kafka-connect-elasticsearch/

https://sematext.com/blog/kafka-connect-elasticsearch-how-to/

## Debezium connector for SQL Server

To enable the Debezium SQL Server connector to capture change event records for database operations, you must first enable change data capture on the SQL Server database. CDC must be enabled on both the database and on each table that you want to capture.

https://debezium.io/documentation/reference/1.8/connectors/sqlserver.html

https://docs.microsoft.com/en-us/sql/relational-databases/track-changes/about-change-data-capture-sql-server?view=sql-server-ver15
https://docs.confluent.io/kafka-connect-jdbc/current/sink-connector/index.html
## Start docker containers

```shell
# Start the topology as defined in https://debezium.io/documentation/reference/stable/tutorial.html
export DEBEZIUM_VERSION=1.8
docker-compose up -d

```
## Using SQL Server
### Initialize database and insert test data
Login to sql server using Sql server Management studio 

![Alt text](/assert/images/sqllogin.png?raw=true "Title")

execute inventory.sql in order to create TestDb and tables

![Alt text](/assert/images/sqlrun.png?raw=true "Title")

### Start SQL Server connector
```shell
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-sqlserver.json
```

### Start the Elastic Sink connector
```shell
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d @es-sink.json
```

### Check the register connectors
```shell
curl -H "Accept:application/json" localhost:8083/connectors/
```
### Modify records in the database via SQL Server client (do not forget to add `GO` command to execute the statement)
```shell
docker-compose -f docker-compose.yaml exec sqlserver bash -c '/opt/mssql-tools/bin/sqlcmd -U sa -P $SA_PASSWORD -d testDB'
```
### Shut down the cluster
```shell
docker-compose  down
```
### Additional

There are mainly two platform/frameworks that are used to create streaming data pipeline
#### Kinesis- 
AWS Managed service. By using AWS DMS(Data MigrationService) and Kinesis one can create a real-time data ingestion pipeline to stream CDC events from a databas.
#### Kafka-
Open Source and most widely used. The AWS also has managed Kafka service by the name AWS MSK

