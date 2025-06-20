select "CUSTOMER_ID",
    null LINK_CLASS,
    --apex_page.get_url(p_items => 'P15_CUSTOMER_ID', p_values => "CUSTOMER_ID") LINK,
    '#' as LINK,
    null ICON_CLASS,
    'data-customer-id=' || CUSTOMER_ID ||' class="t-MediaList-itemWrap' AS LINK_ATTR,
    null ICON_COLOR_CLASS,
    case when coalesce(:P15_CUSTOMER_ID,'0') = "CUSTOMER_ID"
      then 'is-active' 
      else ' '
    end LIST_CLASS,
    'Customer ID: ' || (substr("CUSTOMER_ID", 1, 50)||( case when length("CUSTOMER_ID") > 50 then '...' else '' end )) LIST_TITLE,
    (substr("CUST_FIRST_NAME", 1, 25)||' ' ||(substr("CUST_LAST_NAME", 1, 25))|| ( case when length("CUST_FIRST_NAME") > 50 then '...' else '' end )) LIST_TEXT,
    null LIST_BADGE
from "OEHR_CUSTOMERS" x
where exists (
  select 1
  from "OEHR_ORDERS"
  where "CUSTOMER_ID" = x."CUSTOMER_ID"
)
and (:P15_SEARCH is null
        or upper(x."CUSTOMER_ID") like '%'||upper(:P15_SEARCH)||'%'
        or upper(x."CUST_FIRST_NAME") like '%'||upper(:P15_SEARCH)||'%'
    ) 
order by "CUSTOMER_ID"
