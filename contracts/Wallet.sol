// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

contract Wallet {

    address payable public owner;
    mapping(address => uint) public transferLimit;
    mapping(address => bool) public isAllowedToSend;
    
    constructor(){
        owner = payable(msg.sender);
    }

    function setTransferLimit(address _to, uint _amount) public {
        require(msg.sender == owner, "You are not the owner, aborting");
        transferLimit[msg.sender] = _amount; 
        if(_amount > 0) {
            isAllowedToSend[_to] = true;
        }
        else{
            isAllowedToSend[_to] = false;
       
        }
    }

    function transfer(address payable _to, uint _amount, bytes memory _payload) public returns(bytes memory){
        require(msg.sender ==owner, "You are not the owner, aborting");
        require(_amount <= address(this).balance, "Can't send more than the contract owns, aborting");
        if (msg.sender != owner) {
            require(transferLimit[msg.sender] >= _amount, "You are trying to send more than you are allowed to, aborting");
            require(isAllowedToSend[msg.sender], "You are not allowed to send anything from this smart contract");

            transferLimit[msg.sender] -= _amount;
        }
        (bool success, bytes memory returnData) = _to.call{value: _amount}(_payload);
        require(success, "Aborting, call was not successful");
        return returnData;
    }

    receive() external payable {}
 
}  