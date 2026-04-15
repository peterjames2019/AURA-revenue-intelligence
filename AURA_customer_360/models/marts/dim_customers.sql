with customers as (
    -- Get unique customers from our retail data
    select customer_id, 
    max(country) as country 
    from {{ ref('stg_retail_orders') }}
    group by 1

),

order_stats as (
    -- Calculate total spend and order count per customer
    select 
        customer_id,
        count(distinct invoice_id) as total_orders,
        sum(total_order_value) as lifetime_value,
        max(order_date) as last_purchase_date
    from {{ ref('stg_retail_orders') }}
    group by 1
),

tickets as (
    -- Count how many times they contacted support
    select 
        customer_id,
        count(ticket_id) as total_support_tickets
    from {{ ref('stg_crm_tickets') }}
    group by 1
),

marketing as (
    select 
        customer_id,
        max(is_subscribed::int)::boolean as is_subscribed
    from {{ ref('stg_marketing_stats') }}
    group by 1
)

select
    c.customer_id,
    c.country,
    coalesce(o.total_orders, 0) as total_orders,
    coalesce(o.lifetime_value, 0) as lifetime_value,
    coalesce(t.total_support_tickets, 0) as support_ticket_count,
    coalesce(m.is_subscribed, false) as is_email_subscriber,
    o.last_purchase_date
from customers c
left join order_stats o on c.customer_id::text = o.customer_id::text
left join tickets t on c.customer_id::text = t.customer_id::text
left join marketing m on c.customer_id::text = m.customer_id::text 