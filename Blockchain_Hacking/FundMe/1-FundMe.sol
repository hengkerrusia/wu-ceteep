// SPDX-License-Identifier: MIT

pragma solidity >=0.8.18 <0.9.0;

contract FundMe{

    function fund() public payable {
        // Allow users to send $
        // Have a minimum $ sent
        // 1. How do we send ETH to this contract?

        require(msg.value > 1e18, "uang tidak cukup");
    } 
}
