select 
    "ProductID" as product_id,
    "ListPrice" as list_price,
    "ModifiedDate" as modified_date,
    "StartDate" as list_price_start_date,
    "EndDate" as list_price_end_date
from {{ source('Production', 'ProductListPriceHistory') }}
