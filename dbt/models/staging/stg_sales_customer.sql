select
    "StoreID" as customer_store_id,
    "PersonID" as customer_person_id,
    "CustomerID" as customer_id,
    "TerritoryID" as customer_territory_id,
    "AccountNumber" as customer_account_number,
    "ModifiedDate" as customer_modified_date
from {{ source('Sales', 'Customer') }}