-- @StartDate, @EndDate : Date range to copy data from source to target
-- @targetProject - Target Project ID where the tables are being copied ( Ex: fictional-bank-dev)
-- @sourceProject - Source Project ID for the tables being copied ( Ex: fictional-bank-prd)
WITH 
sequences AS 
( 
    --Generate a list of Dates to copy partitions
    SELECT generate_date_array(@StartDate,@EndDate) AS date_range 
),
project_ids as
( 
    SELECT @targetProject target_prj_id,@sourceProject source_prj_id
),
table_list_csv as
(
  -- Breakdown a CSV list of tables into an array
  select split(@tableListCSV,',') table_list_array
),
table_list as
(
  -- Convert array of tables to an ordered list of tables
  select id,table_name
  from table_list_csv, unnest(table_list_array) as table_name with offset id
  
),
copy_commands as
(
    SELECT table_list.id
        ,concat("bq cp -f '"
                ,project_ids.source_prj_id,":",table_name
                ,'$',format_date('%Y%m%d',partition_date)
                ,"' '"
                ,project_ids.target_prj_id,":",table_name
                ,'$',format_date('%Y%m%d',partition_date)
                ,"' ") cmd                
    FROM sequences CROSS JOIN UNNEST(sequences.date_range) AS partition_date 
    CROSS JOIN table_list 
    CROSS JOIN project_ids
)
select cmd command from copy_commands 
order by id,cmd

