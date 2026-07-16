select
    "Bonus" as bonus,
    "SalesYTD" as sales_ytd,
    "SalesQuota" as sales_quota,
    "TerritoryID" as territory_id,
    "ModifiedDate" as modified_date, --
    "CommissionPct" as commission_pct,
    "SalesLastYear" as sales_last_year,
    "BusinessEntityID" as business_entity_id
from {{ source('Sales', 'SalesPerson') }}
