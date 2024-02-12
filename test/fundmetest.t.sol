// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

import {Test} from "forge-std/Test.sol";

contract fundmetest is Test {
    uint256 number = 1;
    function setUp() external {
        number = 2;
    }

    function testdemo() external {
        assertEq(number,2);
        console.log(number)
    }
}