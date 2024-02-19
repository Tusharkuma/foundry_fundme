// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract fundmetest is Test,FundMe {
    // uint256 number = 1;
    FundMe fundme;
    function setUp() external {
        fundme = new FundMe();
    }

    function testdemo() external {
        // assertEq(number,2);
        // console.log(number);
        assertEq(fundme.MINIMUM_USD(),5e18);

    }

    function testsendisowner() public {
        console.log(fundme.i_owner());  //0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
        console.log(msg.sender);        //0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
        console.log(address(this));     //0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496
             
        assertEq(fundme.i_owner(),address(this));
    }
}