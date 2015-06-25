# Drill Notes

## General
* Meta data repository: A metadata repository is a database created to store metadata. Metadata is information about the structures that contain the actual data.

## Drill
### Definitions and Notes
* Storage Plugins (1): Drill uses storage plugins that correspond to data sources.

* Storage Plugins (2):  A storage plugin defines the abstraction on the data sources for Drill to talk to and provides interfaces to read/write and get metadata from the data source. Each storage plugin also exposes optimization rules for Drill to leverage for efficient query execution.

* The maprdb storage plugin handles HBase as well as MapR-DB.

* MapR-DB: enterprise grade in-Hadoop NoSQL database.


### Setup
#### Networking
* Switched to host-only networking as NAT didn't work.
* Set fixed IP in VM (192.168.33.2)
* Also added below entry to laptop's /etc/hosts:

  192.168.33.2	maprdemo

#### Squirrel
* Use 0.7.0 driver.
* In alias:

  jdbc:drill:zk=192.168.33.2:5181/drill/demo_mapr_com-drillbits
  User Name: mapr
  Password: mapr

### Sample Data
* The "cp" stuff is in jars in the classpath.

#### JSON
* JAR: apache-drill-0.6.0-incubating/jars/3rdparty/mondrian-data-foodmart-json-0.3.2.jar

  SELECT * FROM cp.`department.json`

#### Parquet
* JAR: apache-drill-0.6.0-incubating/jars/3rdparty/tpch-sample-data-0.6.0-incubating.jar

  SELECT * FROM cp.`tpch/supplier.parquet` limit 5;

* Note the slash!

### Added new data source
* mine
* (see data_source_config.json)
* Check that it shows up:

  show databases;
  use mine;


### Querying across data sources
