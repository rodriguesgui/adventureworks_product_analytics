select 
    "Bin" as product_bin,
    "Shelf" as product_shelf,
    "Quantity" as product_quantity,
    "ProductID" as product_id,
    "LocationID" as product_location_id,
    "ModifiedDate" as product_inventory_modified_date
from {{ source('Production', 'ProductInventory') }}
