pragma solidity ^0.4.18;

import './Erc20Impl.sol';
import './common/safemath.sol';
import './common/owned.sol';
import './sale/Payout.sol';
import './sale/Presale.sol';
import './payment/RPYPaymentRecipient.sol';

contract RPY is owned, TokenERC20, Payout, Presale
{
    mapping (address => bool) public frozenAccount;

    event FrozenFunds(address target, bool frozen);

    function RPY(address _payoutAddress, uint _payoutRate) 
        TokenERC20(5000 * 300, "RPY", "RPY")
        Payout(_payoutAddress, _payoutRate)
        Presale(60)
        public {
            
        payoutAddress = _payoutAddress;
        payoutRate = _payoutRate;
    }
    
    function purchase(address _spender, uint _value, string _itemCode, uint _quantity)
        public
        returns (bool success) {
        RPYPaymentRecipient spender = RPYPaymentRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.onRPYPayment(msg.sender, _value, this, _itemCode, _quantity);
            return true;
        }
    }
    
    function _transfer(address _from, address _to, uint _value) internal {
        require (_to != 0x0);
        require (_balanceOf[_from] >= _value);
        require (_balanceOf[_to] + _value > _balanceOf[_to]);
        require(!frozenAccount[_from]); 
        require(!frozenAccount[_to]); 
        
        _balanceOf[_from] -= _value;
        _balanceOf[_to] += _value;
        Transfer(_from, _to, _value);
    }

    function freezeAccount(address target, bool freeze) onlyOwner public {
        frozenAccount[target] = freeze;
        FrozenFunds(target, freeze);
    }
    
    function salesUntil() view public returns (uint) {
        return _balanceOf[this];
    }

    function buy() payable public {
        require(msg.value >= 1 finney);
        require(!frozenAccount[msg.sender]);
        
        uint256 amount = msg.value * exchangeRate();
        _transfer(this, msg.sender, amount);
        
        payoutAmount += msg.value / 10 * payoutRate;
    }
    function refund(uint amount) inPresale public {
        require(amount >= 1 finney);
        require(!frozenAccount[msg.sender]);
        
        _transfer(msg.sender, this, amount);
        uint value = amount / exchangeRate();
        
        require(this.balance >= value);
        
        msg.sender.transfer(value);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
        
        payoutAmount -= value / 10 * payoutRate;
    }
    
    function exchangeRate() public view returns (uint) {
        if (isPresalePeriod()) return 7000;
        else return 5000;
    }
    function fixedExchangeRate() public pure returns (uint) {
        return 5000;
    }
    
    // FOR CO-WORKER
    function payout() notInPresale public {
        _payout();
    }
    // FOR CONTRACT OWNER
    function withdraw() onlyOwner notInPresale public {
        _withdraw();
    }
}
