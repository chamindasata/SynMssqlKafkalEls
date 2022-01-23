# SQL Server Debezium Kafka ElasticSearch
We can set up a simple streaming pipeline to ingest CDC events from SQL Server to Kafka using Debezium and Kafka Connect and the Confluent Elasticsearch connector is continuously reading those same topics and writing the events into Elasticsearch.
## Topology
Here’s a diagram that shows how the data is flowing through our distributed system. First, the Debezium SQL Server connector is continuously capturing the changes from the SQL Server database, and sending the changes for each table to separate Kafka topics. Then, the Confluent JDBC sink connector is continuously reading those topics  and the Confluent Elasticsearch connector is continuously reading those same topics and writing the events into Elasticsearch.

![Alt text](/assert/images/topology.png?raw=true "Title")
https://docs.confluent.io/kafka-connect-jdbc/current/sink-connector/index.html

## Kafka Connect Elasticsearch Connector
The kafka-connect-elasticsearch is a Kafka Connector for copying data between Kafka and Elasticsearch.

https://github.com/confluentinc/kafka-connect-elasticsearch

## Debezium connector for SQL Server

To enable the Debezium SQL Server connector to capture change event records for database operations, you must first enable change data capture on the SQL Server database. CDC must be enabled on both the database and on each table that you want to capture.

https://debezium.io/documentation/reference/1.8/connectors/sqlserver.html

https://docs.microsoft.com/en-us/sql/relational-databases/track-changes/about-change-data-capture-sql-server?view=sql-server-ver15

## Start docker containers

```shell
# Start the topology as defined in https://debezium.io/documentation/reference/stable/tutorial.html
export DEBEZIUM_VERSION=1.8
docker-compose  docker-compose.yaml up

```
## Using SQL Server
### Initialize database and insert test data
Login to sql server using Sql server Management studio 

![Alt text](/assert/images/sqllogin.png?raw=true "Title")

execute inventory.sql in order to create TestDb and tables

![Alt text](/assert/images/sqlrun.png?raw=true "Title")

```shell
# Start SQL Server connector
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-sqlserver.json

# Consume messages from a Debezium topic
docker-compose -f docker-compose-sqlserver.yaml exec kafka /kafka/bin/kafka-console-consumer.sh \
    --bootstrap-server kafka:9092 \
    --from-beginning \
    --property print.key=true \
    --topic server1.dbo.customers

# Modify records in the database via SQL Server client (do not forget to add `GO` command to execute the statement)
docker-compose -f docker-compose-sqlserver.yaml exec sqlserver bash -c '/opt/mssql-tools/bin/sqlcmd -U sa -P $SA_PASSWORD -d testDB'

# Shut down the cluster
docker-compose -f docker-compose-sqlserver.yaml down
```