select
    "OrderQty" as order_quantity,
    "ProductID" as product_id,
    "LineTotal" as line_total,
    "UnitPrice" as unit_price,
    "ModifiedDate" as modified_date,
    "SalesOrderID" as sales_order_id,
    "SpecialOfferID" as special_offer_id,
    "UnitPriceDiscount" as unit_price_discount,
    "SalesOrderDetailID" as sales_order_detail_id, --
    "CarrierTrackingNumber" as carrier_tracking_number
from {{ source('Sales', 'SalesOrderDetail') }}
