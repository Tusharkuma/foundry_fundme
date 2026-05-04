// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {Script} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "../src/fundme.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    
    //must make a function run
    function run() external returns(FundMe)  {
        //helper function for chainlink priceFeed autodetect, according to deployed chain
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        //foundry specific functions, start broadcast and stop broadcast to rpc
        vm.startBroadcast();
        //send deploy contract here inside it
        FundMe fundme = new FundMe(ethUsdPriceFeed);   //deploy new FundMe contract to chain
        vm.stopBroadcast();

        return fundme;
    }
}