cat bqcp_copy_partitions_parallel.sql | bq query --use_legacy_sql=false \
        --parameter=StartDate:DATE:'2020-02-01' \
        --parameter=EndDate:DATE:'2020-02-29'   \
         --parameter=tableListCSV:STRING:'users.user_profiles,products.account_balances,transactions.user_transactions' \
        --parameter=sourceProject:STRING:'fictional-bank-prd' \
        --parameter=targetProject:STRING:'fictional-bank-prd' \
        --parameter=parallelFlg:STRING:'Y' \
        --parameter=parallelSessions:INT64:5 \
        --format=csv | grep -v command > copy_partitions_parallel.sh
#sh copy_partitions_parallel.sh
