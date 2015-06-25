# Connect to Apache Dril.
# RS04032015

library(rJava)
library(RJDBC) 
library(rjson)

setwd("~/Dropbox/work/apache_drill")

#
# Initialize Drill connection.
#
initDrill <- function() {
  Sys.setenv(JAVA_HOME="/usr/lib/jvm/java-7-oracle")
  options(java.parameters="-Xmx2g")
  
  # Output Java version.
  .jinit()
  print(.jcall("java/lang/System", "S", "getProperty", "java.version"))
  
  # Create connection driver and open connection.
  drv <<- JDBC(driverClass="org.apache.drill.jdbc.Driver", classPath="/home/escralp/opt/apache-drill-0.7.0/jars/jdbc-driver/drill-jdbc-all-0.7.0.jar") 
  conn <<- dbConnect(drv, "jdbc:drill:zk=192.168.33.2:5181/drill/demo_mapr_com-drillbits", "mapr", "mapr")
}


#
# A couple of query functions.
#

# Hive query
plotSalesHistogram <- function() {
  # Using Hive.
  dbGetQuery(conn, "use hive")
  
  # Query the orders table.
  sales <- dbGetQuery(conn, "select `month`, cast(sum(order_total) as double) as totalSales
from orders group by `month` order by 2 desc")
  
  View(sales)
  
  barplot(sales$totalSales, names = sales$month, main = "Total Sales (Hive DB)", xlab="Month", ylab="Sales in US$")
}

# Show logs excerpt.
showLogs <- function() {
  dbGetQuery(conn, "use dfs.logs")
  
  logs <- dbGetQuery(conn, "select 
                    cast(dir0 as double) as dir0, 
                     cast(dir1 as double) as dir1, 
                     cast(trans_id as double) as trans_id, 
                    `date`,
                    `time`,
                     cast(cust_id as double) as cust_id,
                     device,
                     cast(camp_id as double) as camp_id,
                     keywords,
                     cast(prod_id as double) as prod_id,
                     purch_flag from logs limit 20")
  View(logs)
}

# Create table of most used devices from logs.
analyzeLogs <- function() {
  dbGetQuery(conn, "use dfs.logs")
  
  allLogs <- dbGetQuery(conn, "select 
                    cast(dir0 as double) as dir0, 
                     cast(dir1 as double) as dir1, 
                     cast(trans_id as double) as trans_id, 
                    `date`,
                    `time`,
                     cast(cust_id as double) as cust_id,
                     device,
                     cast(camp_id as double) as camp_id,
                     keywords,
                     cast(prod_id as double) as prod_id,
                     purch_flag from logs")
  print(table(allLogs$device))
}


#
# Shutdown connection.
#
shutdown <- function() {
  # Close connection
  dbDisconnect(conn)   
}

prepareFaithfulJSON <- function() {
  data(faithful)
  
  # Write "x" values.
  df1 <- data.frame(id=1:length(faithful$eruptions), x = faithful$eruptions)
  sink("data/faithfulx.json")
  cat(toJSON(df1))
  sink()
  
  # Write "y" values.
  df2 <- data.frame(my_id=1:length(faithful$waiting), y=faithful$waiting)
  write.table(df2, file="data/faithfuly.csv", sep=",")
}