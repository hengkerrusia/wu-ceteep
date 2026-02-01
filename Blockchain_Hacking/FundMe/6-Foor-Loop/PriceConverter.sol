// SPDX-License-Identifier: MIT

pragma solidity >=0.8.18 <0.9.0;

import {AggregatorV3Interface} from "./AggregatorV3Interface.sol";

library PriceConverter {

    function getPrice() internal view returns(uint256){
        // Address -> 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();

        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 _ethAmount) internal view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountUSD = (ethPrice * _ethAmount) / 1e18;
        return ethAmountUSD;
    }

    function getVersion() internal view returns(uint256){
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}
