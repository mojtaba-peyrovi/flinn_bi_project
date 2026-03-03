with source as (
    select * from "flinn_bi"."analytics"."hubspot_deals"
),

renamed as (
    select
        cast(deal_id as bigint) as deal_id,
        cast(deal_name as varchar) as deal_name,
        cast(pipeline as varchar) as pipeline,
        cast(is_closed as boolean) as is_closed,
        cast(is_closed_won as boolean) as is_closed_won,
        cast(amount as double) as amount,
        cast(close_date as timestamp) as close_date,
        cast(create_date as timestamp) as create_date,
        cast(hubspot_company_id as bigint) as hubspot_company_id,
        cast(deal_type as varchar) as deal_type,
        cast(currency as varchar) as currency,
        cast(date_entered_pre_pitch as timestamp) as date_entered_pre_pitch,
        cast(date_entered_pitching as timestamp) as date_entered_pitching,
        cast(date_entered_product_testing as timestamp) as date_entered_product_testing,
        cast(date_entered_price_offering as timestamp) as date_entered_price_offering,
        cast(date_entered_contract_negotiation as timestamp) as date_entered_contract_negotiation,
        cast(date_entered_closed_won as timestamp) as date_entered_closed_won,
        cast(date_entered_closed_lost as timestamp) as date_entered_closed_lost
    from source
)

select *
from renamed