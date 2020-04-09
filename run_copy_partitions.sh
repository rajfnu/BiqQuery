cat bqcp_copy_partitions.sql | bq query --use_legacy_sql=false \
        --parameter=StartDate:DATE:'2020-02-01' \
        --parameter=EndDate:DATE:'2020-02-29'   \
         --parameter=tableListCSV:STRING:'users.user_profiles,products.account_balances,transactions.user_transactions' \
        --parameter=sourceProject:STRING:'fictional-bank-prd' \
        --parameter=targetProject:STRING:'fictional-bank-prd' \
        --format=csv | grep -v command > copy_partitions.sh
sh copy_partitions.sh
