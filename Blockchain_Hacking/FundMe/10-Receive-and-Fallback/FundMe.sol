// SPDX-License-Identifier: MIT

pragma solidity >=0.8.18 <0.9.0;

import {PriceConverter} from "./PriceConverter.sol";

contract FundMe{

    uint256 public constant MINIMUM_USD = 5e18;
    address[] public  funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    using PriceConverter for uint256;

    address public immutable owner;

    constructor(){
        owner = msg.sender;
    }

    error notOwner();
    
    function fund() public payable {

        // Allow users to send $
        // Have a minimum $ sent
        // 1. How do we send ETH to this contract?

        // konsep revert

        require(msg.value.getConversionRate() >=  MINIMUM_USD, "uang tidak cukup"); // msg.value dalam bentuk wei. 1 ETH -> 1e18 -> 1000 000 000 000 000 000 wei
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    } 

    // for loop
    function withdraw() public onlyOwner{
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0); // reset array
        
        (bool succeskirim, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(succeskirim, "call failed");
    }

    // Receive and Fallback

    // receive() dipanggil ketika ETH dikirim tanpa data
    receive() external payable {
        fund();
    }

    // fallback() dipanggil ketika :
    // - fungsi tidak ditemukan 
    // - ETH dikirim dengan data
    fallback() external payable {
        fund();
    }

    modifier onlyOwner() {
        // require(owner == msg.sender, "Bukan owner woi!");
        //bisa diganti seperti dibawah
        if(owner != msg.sender) revert notOwner();
        _;
    }
}
