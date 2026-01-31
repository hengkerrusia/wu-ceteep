// SPDX-License-Identifier: MIT

pragma solidity >=0.8.18 <0.9.0;

import {AggregatorV3Interface} from "./AggregatorV3Interface.sol";

contract FundMe{

    function fund() public payable {
        // Allow users to send $
        // Have a minimum $ sent
        // 1. How do we send ETH to this contract?

        // konsep revert

        require(msg.value > 1e18, "uang tidak cukup");
    } 

    function getPrice() public view returns(uint256){
        // Address -> 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();

        return uint256(price * 1e10);
    }

    function getConversionRate() public {}

    function getVersion() public view returns(uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}
