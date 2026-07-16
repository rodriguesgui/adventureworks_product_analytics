SELECT gross_margin_pct as value, 'gross_margin_pct' as column_name
FROM {{ ref('fact_sales') }}
WHERE gross_margin_pct > 1

UNION ALL

SELECT unit_price_discount as value, 'unit_price_discount' as column_name
FROM {{ ref('fact_sales') }}
WHERE unit_price_discount < 0 OR unit_price_discount > 1