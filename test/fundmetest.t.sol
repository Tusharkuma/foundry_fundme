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
        

    }
}