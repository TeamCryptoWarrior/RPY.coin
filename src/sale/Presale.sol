contract Presale {
    uint public START;
    uint public periodInDays;
    
    function Presale(uint _periodInDays) public {
        START = now;
        
        periodInDays = _periodInDays;
    }
    
    modifier notInPresale {
        require(!isPresalePeriod());
        _;
    }
    modifier inPresale {
        require(isPresalePeriod());
        _;
    }
    
    function isPresalePeriod() public view returns (bool) {
        return START + (periodInDays * 1 days) > now;
    }
}
