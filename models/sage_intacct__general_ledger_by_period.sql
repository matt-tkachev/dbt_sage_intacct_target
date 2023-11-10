
with general_ledger_balances as (
    select *
    from {{ ref('int_sage_intacct__general_ledger_balances') }}
), 

final as (
    select 
        location_id,
        location_name,
        account_no,
        account_title,
        book_id,
        category,
        classification,
        currency,
        entry_state,
        account_type,
        date_year, 
        period_first_day,
        period_last_day

        {% if var('sage_account_pass_through_columns') %} 
        ,
        {{ var('sage_account_pass_through_columns') | join (", ")}}

        {% endif %}
        ,
        round(cast(period_net_amount as {{ dbt.type_numeric() }}),2) as period_net_amount,
        round(cast(period_beg_amount as {{ dbt.type_numeric() }}),2) as period_beg_amount,
        round(cast(period_ending_amount as {{ dbt.type_numeric() }}),2) as period_ending_amount
    from general_ledger_balances
)

select * 
from final 
