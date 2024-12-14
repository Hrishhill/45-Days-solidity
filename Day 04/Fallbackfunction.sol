// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

// Define Fallback function
// 1. Cannot have a name (anonymous)
// 2. Does not take any inputs
// 3. Must be declared as external

// Fallback contract
contract FallBack {
    event Log(uint gas);

    // The receive function for receiving Ether without any data
    receive() external payable {
        // Emit log when Ether is received without data
        emit Log(gasleft());
    }

    // The fallback function for handling calls with data or Ether without matching functions
    fallback() external payable {
        // Not recommended to write much code here because the function will fail if it uses too much gas
        // Invoke the send method: we get 2300 gas which is enough to emit a log
        // Invoke the call method: we get all the gas
        emit Log(gasleft());
    } 

    // Function to get the balance of the contract
    function getBalance() public view returns(uint) {
        // Return the contract's balance
        return address(this).balance;    
    }
}

// New contract will send ether to FallBack contract which will trigger the fallback function
contract sendToFallback {
    // Corrected function name from tarnsferToFallBack to transferToFallback
    function transferToFallback(address payable _to) public payable {
        // Send ether with the transfer method
        // Automatically transfers 2300 gas amount
        _to.transfer(msg.value);
    }

    // Function using the call method
    function callFallback(address payable _to) public payable {
        // Call method: This allows passing more gas than the transfer method
        (bool sent, ) = _to.call{value: msg.value}('');
        require(sent, "Failed to send");
    }
}

