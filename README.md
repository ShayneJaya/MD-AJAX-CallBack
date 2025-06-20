# MD-AJAX-CallBack
Set up a simple AJAX callback for the prebuilt APEX Master Detail Side by Side Report
This repository contains a minimal working example of how to wire up an AJAX callback between a “master” Interactive Grid (or Media List) and a “detail” region in Oracle APEX, laid out side-by-side. Selecting a customer in the master pane sets a page item via a PL/SQL process and automatically refreshes the detail and header panes.

---

## Prerequisites

- Oracle APEX 24.2 (compatible with earlier version of APEX as well)  
- A workspace with the **OEHR** sample schemas  
- Basic familiarity with APEX regions, page items, and Dynamic Actions  

---

## Usage

1. Navigate to your APEX page.  
2. Click on any customer in the master list.  
3. Behind the scenes:  
   1. The JS grabs the `data-customer-id`.  
   2. It calls the `SET_CUSTOMER_ID` process via `apex.server.process`.  
   3. On success, it refreshes the **DETAILS** and **HEADER** regions—showing the selected customer’s detail.  

---

## How It Works
Youtube Link


