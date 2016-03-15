#!/usr/bin/env bash

# set up configurations
source "`pwd`/benchmark.conf";

QUERY_DIR=$1;

if [ -e "$LOG_FILE" ]; then
	timestamp=`date "+%F-%R" --reference=$LOG_FILE`
	backupFile="$LOG_FILE.$timestamp"
	mv $LOG_FILE $LOG_DIR/$backupFile
fi

if [ $# == 0 ]; then
  echo "USAGE: 
  ./tpch_benchmark.sh script_folder_name
  e.g. ./tpch_benchmark.sh tpch
  "; exit 1;
fi

echo ""
echo "***********************************************"
echo "*           PC-H benchmark on Hive            *"
echo "***********************************************"
echo "                                               " 
echo "Running Hive from $HIVE_HOME" | tee -a $LOG_FILE
echo "Running Hadoop from $HADOOP_HOME" | tee -a $LOG_FILE
echo "See $LOG_FILE for more details of query errors."
echo ""



trial=0
while [ $trial -lt $NUM_OF_TRIALS ]; do
	trial=`expr $trial + 1`
echo "Executing Trial #$trial of $NUM_OF_TRIALS trial(s)..."

	for query in ${HIVE_TPCH_QUERIES_ALL[@]}; do
		echo "Running Hive query: $query" | tee -a $LOG_FILE
		$TIME_CMD $HIVE_CMD -f $BASE_DIR/$QUERY_DIR/$query.hive 2>&1 | tee -a $LOG_FILE | grep '^Time:'
               returncode=${PIPESTATUS[0]}
		if [ $returncode -ne 0 ]; then
			echo "ABOVE QUERY FAILED:$returncode"
		fi
	done

done # TRIAL
echo "***********************************************"
echo ""
