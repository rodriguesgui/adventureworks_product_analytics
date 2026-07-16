SELECT
    "ProductID" as product_id,
    "StandardCost" as product_standard_cost,
    "ModifiedDate" as product_modified_date,
    "EndDate" as end_date,
    "StartDate" as start_date --
from {{ source('Production', 'ProductCostHistory') }}