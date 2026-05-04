//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {FundMe} from "../src/fundme.sol";
import {DeployFundMe} from "../script/DeployFundMe.sol";

contract FundMetest is Test {
    FundMe fundme;
    address USER = makeAddr("testuser");    //foundry cheatcodes
    uint256 constant STARTING_VALUE = 10 ether;
    uint256 constant SEND_VALUE = 0.1 ether;    //100000000000000000000 i.e 1e17 wie


    //first step is to make a setup() function
    function setUp() external {
        //need to deploy the contract to test it
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundme = deployFundMe.run();
        vm.deal(USER, STARTING_VALUE);
    }

    function testMinimumDollarIsFive() public {
        //use assertEq( , ), to test the function with desired result
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testIOwner() public {
        address addressOfThisContract = address(this);
        console.log(addressOfThisContract);
        console.log("msg.sender is", msg.sender);
        console.log(fundme.getOnlyOwner());

        assertEq(fundme.getOnlyOwner(), msg.sender);
    }

    function testFundUpdatesFundDataStructure() public {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        uint256 valueOfAddress = fundme.addressToAmountFunded(USER);
        assertEq(valueOfAddress , 0.1 ether);
    }

    function testRevertFundWithZeroValue() public {
        //foundry cheatcode to know if the next line should revert. if fails then test will pass else test function will fail. and its designed to be fail by reverting successfull
        vm.expectRevert();
        fundme.fund();
    }

    //test funder's list in funder list
    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        console.log(USER);
        fundme.fund{value: SEND_VALUE}();
        address funderAdd = fundme.funders(0);
        console.log(funderAdd);
        assertEq(funderAdd, USER);
    }

    //test only owner 
    function testOnlyOwner() public {
        address t_OnlyOwner = fundme.getOnlyOwner();
        assertEq(t_OnlyOwner, msg.sender);
    }

    //test only owner can withdraw
    function testUserCannotWithdraw() public {
        //user funds the contract
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();

        //same user try to withdraw from the contract
        //expected a revert
        vm.expectRevert();
        vm.prank(USER);
        fundme.withdraw();

    }

    //modifier for prank trx and funding contract
    modifier funded() {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        assert(address(fundme).balance >0);
        _;
    }

    //test onlyowner can withdraw
    function testOnlyOwnerCanWithdrawRevert() public funded {
        vm.expectRevert();
        fundme.withdraw();
    }

    //test withdraw funds by onlyowner
    function testOnlyOwnerCanWithdraww() public {
        //step 1 is to fund the amount 
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        console.log(address(fundme).balance);
        //step 2 is to withdraw
        address ownerAddress = fundme.getOnlyOwner();
        vm.prank(ownerAddress);
        fundme.withdraw();
        //current balance of contract 
        uint256 currentBalance = address(fundme).balance;
        console.log(currentBalance);
        assertEq(currentBalance, 0);
    }

    //now test onlyowner can withdraw after multiple funders
    //using hoax from stdcheat of foundry, hoax = (prank + deal)
    function testWithdrawFromMultipleFunders() public funded {
        //AAA testing standard- Arrange, Act, Assert
        //arrange
        uint160 totalFunders = 10;
        uint160 initialFunderAddressIndex = 1;

        uint256 ownerInitialFunds = fundme.getOnlyOwner().balance;
        uint256 ownerFinalFunds = ownerInitialFunds + address(fundme).balance;

        //act (logical part)
        //steps- all the funders will fund contract with send_value. 2nd step- the total fund will be withdraw by onlyowner

        for(uint160 i=initialFunderAddressIndex; i< totalFunders + 1; i++ ) {
            //funding logic
            hoax(address(i),SEND_VALUE);
            fundme.fund{value: SEND_VALUE}();
        }

        //withdrawal logic
        vm.prank(fundme.getOnlyOwner());
        fundme.withdraw();


        //assert
        assertEq(fundme.getOnlyOwner().balance, ownerFinalFunds);
        //test if the withdraw amount is equal to the total funded amount of contract by all funders
        assertEq((totalFunders + 1) * SEND_VALUE , fundme.getOnlyOwner().balance - ownerInitialFunds);
        assertEq(address(fundme).balance, 0);
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        uint160 totalFunders = 10;
        uint160 initialFunderAddressIndex = 1;

        uint256 ownerInitialFunds = fundme.getOnlyOwner().balance;
        uint256 ownerFinalFunds = ownerInitialFunds + address(fundme).balance;

        //act (logical part)
        //steps- all the funders will fund contract with send_value. 2nd step- the total fund will be withdraw by onlyowner

        for(uint160 i=initialFunderAddressIndex; i< totalFunders + 1; i++ ) {
            //funding logic
            hoax(address(i),SEND_VALUE);
            fundme.fund{value: SEND_VALUE}();
        }

        //withdrawal logic
        vm.prank(fundme.getOnlyOwner());
        fundme.cheaperWithdraw();


        //assert
        assertEq(fundme.getOnlyOwner().balance, ownerFinalFunds);
        //test if the withdraw amount is equal to the total funded amount of contract by all funders
        assertEq((totalFunders + 1) * SEND_VALUE , fundme.getOnlyOwner().balance - ownerInitialFunds);
        assertEq(address(fundme).balance, 0);
    }
    // function decodeAddress() public returns(address){

    //     address contractAddress= 0xCE3478A9E0167a6Bc5716DC39DbbbfAc38F27623;
    //     (bool success, bytes memory data ) = contractAddress.call(
    //         abi.encodeWithSignature("i_owner()")
    //     );

    //     require(success);
    //     return abi.decode(data, (address));
    // }

    // function testingOwner() public {
    //     assertEq(decodeAddress(), msg.sender);
    // }
}


//sudocode-     1: calculate gas cost; 2: calculate withdraw gas cost; 3: optimize withdraw function;