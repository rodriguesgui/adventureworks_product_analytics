select
    "Name" as sales_store_name,
    "Demographics" as sales_store_demographics, --
    "ModifiedDate" as sales_store_modified_date,
    "BusinessEntityID" as sales_store_business_entity_id,
    "SalesPersonID" as sales_store_sales_person_id
from {{ source('Sales', 'Store') }}