#!/bin/bash
source "`pwd`/benchmark.conf";

TABLE_SUFFIX="_parquet"

TEST_RESULT_DIR=$BASE_DIR/result
rm -rf $TEST_RESULT_DIR
mkdir $TEST_RESULT_DIR

CURRENT_CRITERION_DIR=$TEST_RESULT_DIR/criterion
rm -rf $CURRENT_CRITERION_DIR
mkdir $CURRENT_CRITERION_DIR

CURRENT_RESULT_DIR=$TEST_RESULT_DIR/testresult
rm -rf $CURRENT_RESULT_DIR
mkdir $CURRENT_RESULT_DIR

DIFF_DIR=$TEST_RESULT_DIR/diff
rm -rf $DIFF_DIR
mkdir $DIFF_DIR

TEST_REPORT_FILE=$TEST_RESULT_DIR/report

for query in ${HIVE_TPCH_QUERIES_ALL[@]}; do
		echo "";
		echo "Download criterion $query from Hive";
		CRITERION_FILE=$CURRENT_CRITERION_DIR/$query;
		$HIVE_CMD -e "select * from $query" > $CRITERION_FILE;
			
		echo "";
		echo "Download test result $query$TABLE_SUFFIX from Hive";
		RESULT_FILE=$CURRENT_RESULT_DIR/$query;
		$HIVE_CMD -e "select * from $query$TABLE_SUFFIX" > $RESULT_FILE;
	
		echo "";
                echo "diff the test result from the criterion";		
		DIFF_FILE="$DIFF_DIR/$query.diff"
		diff $CRITERION_FILE $RESULT_FILE > $DIFF_FILE
		result=$(cat $DIFF_FILE);

		TEST_RESULT="Failed";		
		if [[ -z $CRITERION_FILE ]] || [[ -z $RESULT_FILE ]]; then
			TEST_RESULT="Failed";
		else
			if [[ -z $result ]]; then
				TEST_RESULT="OK";
			else
				TEST_RESULT="Failed";
			fi
		fi
		printf "Test '%50s'...[%s]\n" $query $TEST_RESULT  >> $TEST_REPORT_FILE;
	done






