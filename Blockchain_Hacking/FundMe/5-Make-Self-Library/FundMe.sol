// SPDX-License-Identifier: MIT

pragma solidity >=0.8.18 <0.9.0;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{

    uint256 public minimumUSD = 5e18;
    address[] public  funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    using PriceConverter for uint256;
    
    function fund() public payable {

        // Allow users to send $
        // Have a minimum $ sent
        // 1. How do we send ETH to this contract?

        // konsep revert

        require(msg.value.getConversionRate() >=  minimumUSD, "uang tidak cukup"); // msg.value dalam bentuk wei. 1 ETH -> 1e18 -> 1000 000 000 000 000 000 wei
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    } 

    
}
