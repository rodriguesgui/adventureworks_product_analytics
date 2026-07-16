select 
    sss.sales_store_name as store_name,
    sss.sales_store_sales_person_id as person_id,
    sss.sales_store_business_entity_id as store_id,
    sst.sales_territory_id as territory_id,
    sst.sales_territory_name as territory_name,
    sst.sales_territory_group as  territory_group,
    sst.sales_territory_country_region_code as country_region_code
from
    {{ ref('stg_sales_store') }} as sss
    left join {{ ref('stg_sales_person') }} as ssp
    on sss.sales_store_sales_person_id = ssp.business_entity_id
    left join {{ ref('stg_sales_territory') }} as sst
    on ssp.territory_id = sst.sales_territory_id

UNION ALL

select
    'Online' as store_name,
    -1 as person_id,
    -1 as store_id,
    -1 as territory_id,
    'Online' as territory_name,
    'Online' as territory_group,
    'N/A' as country_region_code
    