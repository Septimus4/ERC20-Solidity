pragma solidity ^0.8.0;

/**
 * EtherSplitter
 * Splits transferred Ether
 */

contract EtherSplitter {
    address payable user1;
    address payable user2;

    constructor(address payable _user1, address payable _user2) {
        user1 = _user1;
        user2 = _user2;
    }
    
    modifier ethNeeded {
        require(msg.value > 0, "You must provide ETH to be split between addresses");
        _;
    }

    function pay(address payable addr, uint sum) private returns (bool check) {
        check = addr.send(sum);
        return check;
    }

    function eth_split() payable public  returns (bool status) {
        uint eth = msg.value;
        uint payable_eth = eth / 2;
        uint return_to_sender = eth % 2;

        status = pay(user1, payable_eth);
        status = pay(user2, payable_eth);
        
        if (address(this).balance > 0) {
            payable (msg.sender).send(address(this).balance);
        } 
        return true;
    }
}
