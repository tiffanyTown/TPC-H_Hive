TPC-H-Hive

This tool is used to run tpc-h benchmark on hive with PARQUET format. And it covers two parts:1.Run the TPC-H queries 2.Validate the results

This README contains the following topics.
1. How to generate and prepare the data
2. How to run the queries
3. How to validate the results

----
1. How to generate and prepare the data
For the DBGEN part, please refer to the README in dbgen folder.
Please copy all the generated data files to the data fol
der. Then "sh tpch_prepare_data.sh" to prepare the data in HDFS.
 
2. How to run the queries
There are two scripts in the package, tpch& tpch_parquet. you can run the queries by "sh tpch_benchmark.sh $scripts_name"
3. How to validate the results
Use "sh validation.sh" to do validation. And you can find the result in the result folder.
