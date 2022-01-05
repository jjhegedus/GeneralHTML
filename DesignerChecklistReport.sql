Select fld.name         as appName,
       tab1.name        as tableName, 
       col.name         as columnName,
       col.prompt       as columnPrompt,
       col.help_text    as columnHint,
       d.name           as domainName,
       col.auto_generated,
       col.server_defaulted_flag,
       col.server_derived_flag,
       col.default_value,
       col.uppercase
       
from ci_domains d
, ci_columns col
, ci_table_definitions tab1 
, sdd_folder_members mem 
, sdd_folders fld
where d.irid(+)               = col.domain_reference
and col.table_reference     = tab1.irid
and mem.member_object       = tab1.irid 
and mem.folder_reference    = fld.irid 
and mem.ownership_flag      = 'Y' 
and tab1.name not like '%_OF'
and tab1.name not like '%_CH'
and tab1.name not like 'DEV_%'
and tab1.name not like 'REF_%'
and mem.ownership_flag      = 'Y' 
--and  tab1.name         like 'IPT%'
and fld.name                = 'HCPCS-J Codes'
order by fld.name,
         tab1.name,
         col.sequence_number


