select 
    "Name" as person_country_region_name,
    "ModifiedDate" as person_country_region_modified_date,
    "CountryRegionCode" as person_country_region_code
from {{ source('Person', 'CountryRegion') }}
