interface RPYPaymentRecipient {
  function onRPYPayment(address _from, uint256 _value, address _token, string itemCode, uint quantity) public;
}
