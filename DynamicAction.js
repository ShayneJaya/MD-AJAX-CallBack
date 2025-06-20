//jQuery Selector .t-MediaList-itemWrap
var customerId = $(this.triggeringElement).data('customer-id');
if (customerId) {
    apex.item('P15_CUSTOMER_ID').setValue(customerId);
    apex.server.process("SET_CUSTOMER_ID", {
        x01: customerId,
    }, {
      dataType: 'text',
      success: function () {
        apex.region("DETAILS").refresh();
        apex.region("HEADER").refresh();
      },
      error: function (jqXHR, textStatus, errorThrown) {
        console.log('Error:', errorThrown);
      }
    });
}
