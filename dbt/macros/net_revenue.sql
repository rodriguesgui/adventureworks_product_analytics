{% macro net_revenue(unit_price, order_quantity, unit_price_discount) %}
    {{ unit_price }} * {{ order_quantity }} * (1 - {{ unit_price_discount }})
{% endmacro %}