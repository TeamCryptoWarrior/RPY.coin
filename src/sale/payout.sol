import './../owned.sol';

contract Payout is owned {
    
    address payoutAddress;
    uint public payoutAmount = 0;
    uint public payoutProcessed = 0;
    uint public payoutRate;
    
    function Payout(address _payoutAddress, uint _payoutRate) {
        payoutAddress = _payoutAddress;
        payoutRate = _payoutRate;
    }
    
    // FOR CO-WORKER
    function _payout() internal {
        require(payoutAmount != 0);
        require(payoutAmount != payoutProcessed);
        
        payoutAddress.transfer(payoutAmount - payoutProcessed);
        
        payoutProcessed = payoutAmount;
    }
    // FOR CONTRACT OWNER
    function _withdraw() onlyOwner internal {
        require(payoutProcessed == payoutAmount);
        
        msg.sender.transfer(this.balance);
    }
}
