// SPDX-License-Idendifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script{
    //based on chainId we will select specifig chain pricefeed of that adddress.
    //this file is used to get the priceFeed address and rather then hardcoding, get the price from here.

    //variables

    struct networkConfig{
        address priceFeed;
    }

    MockV3Aggregator mockPriceFeed;
    uint8 public decimals = 8;
    int256 public initialAnswer = 2000e10;
    networkConfig public activeNetworkConfig;

    constructor() {
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthPrice();
        }else{
            activeNetworkConfig = getAnvilEthPrice();
        }
    }

    function getSepoliaEthPrice() public pure returns(networkConfig memory){
        networkConfig memory sepoliaConfig = networkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
    }

    function getAnvilEthPrice() public returns(networkConfig memory){
        //if we are in local anvil, we will deploy mock, 
        //if on another network, grab the feed address of that network 

        vm.startBroadcast();
        mockPriceFeed = new MockV3Aggregator(decimals, initialAnswer);
        vm.stopBroadcast();

        networkConfig memory anvilConfig = networkConfig({priceFeed: address(mockPriceFeed)});

        return anvilConfig;

    }

}   