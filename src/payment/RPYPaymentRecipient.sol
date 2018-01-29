interface RPYPaymentRecipient { 
    function onRPYPayment(address _from, uint256 _value, address _token, string _itemCode, uint _quantity) public;
}
