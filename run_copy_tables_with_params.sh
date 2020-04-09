# File Name : run_copy_tables_with_params.sh
cat bqcp_copy_tables_with_params.sql  | bq query --use_legacy_sql=false \
        --parameter=tableListCSV:STRING:'users.user_profiles,products.account_balances,transactions.user_transactions' \
        --parameter=sourceProject:STRING:'fictional-bank-prd' \
        --parameter=targetProject:STRING:'fictional-bank-dev' \
        --format=csv | grep -v command > copy_tables.sh
sh copy_tables.sh
