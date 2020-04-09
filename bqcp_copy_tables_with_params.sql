with table_list_csv as
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
project_ids as
(
  -- Gather source and target project IDs
  SELECT @targetProject target_prj_id
  , @sourceProject source_prj_id
),
 copy_commands as
 ( 
   -- create a command of the form
   -- bq cp -f <SOURCE_PROJECT_ID>:<DATASET_NAME>:<TABLE_NAME> <TARGET_PROJECT_ID>:<DATASET_NAME>:<TABLE_NAME> 
   SELECt table_list.id
   ,concat("bq cp -f ",project_ids.source_prj_id,":",table_name," ",project_ids.target_prj_id,":",table_name) command
   from table_list
   CROSS JOIN project_ids
)
select command
from copy_commands
order by id
