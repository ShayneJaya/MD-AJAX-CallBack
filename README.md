# MD-AJAX-CallBack
Set up a simple AJAX callback for the prebuilt APEX Master Detail Side by Side Report

# APEX Side-by-Side Master-Detail AJAX Demo

This repository contains a minimal working example of how to wire up an AJAX callback between a “master” Interactive Grid (or Media List) and a “detail” region in Oracle APEX, laid out side-by-side. Selecting a customer in the master pane sets a page item via a PL/SQL process and automatically refreshes the detail and header panes.

---

## Table of Contents

- [Prerequisites](#prerequisites)  
- [Installation](#installation)  
- [Usage](#usage)  
- [File Structure](#file-structure)  
- [How It Works](#how-it-works)  
  - [1. SET_CUSTOMER_ID.sql](#1-set_customer_idsql)  
  - [2. DynamicAction.js](#2-dynamicactionjs)  
  - [3. SampleQuery.sql](#3-samplequerysql)  
- [Contributing](#contributing)  
- [License](#license)  

---

## Prerequisites

- Oracle APEX 24.x (or later)  
- A workspace with the **OEHR_CUSTOMERS** and **OEHR_ORDERS** sample schemas  
- Basic familiarity with APEX regions, page items, and Dynamic Actions  

---

## Installation

1. **Import the PL/SQL process**  
   - Run `SET_CUSTOMER_ID.sql` in SQL Workshop to create the `SET_CUSTOMER_ID` Application Process.  
2. **Add the Master Region**  
   - Create a Media List or Interactive Grid region on page 15.  
   - Use the **SampleQuery.sql** as its SQL source.  
3. **Create a Page Item**  
   - Add a hidden page item `P15_CUSTOMER_ID`.  
4. **Include the JavaScript**  
   - In your Page 15 or a shared Static File, add **DynamicAction.js**.  
   - Point a Dynamic Action “Custom JavaScript” to run on click of `.t-MediaList-itemWrap`.  

---

## Usage

1. Navigate to your APEX page.  
2. Click on any customer in the master list.  
3. Behind the scenes:  
   1. The JS grabs the `data-customer-id`.  
   2. It calls the `SET_CUSTOMER_ID` process via `apex.server.process`.  
   3. On success, it refreshes the **DETAILS** and **HEADER** regions—showing the selected customer’s detail.  

---

## File Structure


---

## How It Works

### 1. SET_CUSTOMER_ID.sql

```sql
-- Application Process: "SET_CUSTOMER_ID"
BEGIN
  APEX_UTIL.SET_SESSION_STATE(
    p_name  => 'P15_CUSTOMER_ID',
    p_value => APEX_APPLICATION.G_X01
  );
END;


// on click of .t-MediaList-itemWrap
var customerId = $(this.triggeringElement).data('customer-id');

if (customerId) {
  apex.item('P15_CUSTOMER_ID').setValue(customerId);

  apex.server.process("SET_CUSTOMER_ID", {
      x01: customerId
    }, {
      dataType: 'text',
      success: function() {
        apex.region("DETAILS").refresh();
        apex.region("HEADER").refresh();
      },
      error: function(jqXHR, textStatus, errorThrown) {
        console.error('Error setting customer ID:', errorThrown);
      }
  });
}


SELECT
  CUSTOMER_ID,
  null               LINK_CLASS,
  '#'                AS LINK,
  'data-customer-id=' || CUSTOMER_ID 
    || ' class="t-MediaList-itemWrap"' AS LINK_ATTR,
  CASE 
    WHEN :P15_CUSTOMER_ID = CUSTOMER_ID THEN 'is-active'
    ELSE NULL
  END                 LIST_CLASS,
  'Customer ID: ' || CUSTOMER_ID        LIST_TITLE,
  CUST_FIRST_NAME || ' ' || CUST_LAST_NAME LIST_TEXT
FROM OEHR_CUSTOMERS c
WHERE EXISTS (
  SELECT 1 FROM OEHR_ORDERS o
  WHERE o.CUSTOMER_ID = c.CUSTOMER_ID
)
AND ( :P15_SEARCH IS NULL OR
      UPPER(c.CUSTOMER_ID)   LIKE '%'||UPPER(:P15_SEARCH)||'%' OR
      UPPER(c.CUST_FIRST_NAME) LIKE '%'||UPPER(:P15_SEARCH)||'%'
)
ORDER BY CUSTOMER_ID;
