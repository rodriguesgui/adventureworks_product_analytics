select
    "Name" as sales_territory_name,
    "Group" as sales_territory_group,
    "CostYTD" as sales_territory_cost_ytd,
    "SalesYTD" as sales_territory_sales_ytd,
    "TerritoryID" as sales_territory_id,
    "CostLastYear" as sales_territory_cost_last_year, --
    "ModifiedDate" as sales_territory_modified_date,
    "SalesLastYear" as sales_territory_sales_last_year,
    "CountryRegionCode" as sales_territory_country_region_code
from {{ source('Sales', 'SalesTerritory') }}
