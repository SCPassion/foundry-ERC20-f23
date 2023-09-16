// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

// Try to use ChatGPT to help getting started with writing tests.
// Be careful with the bugs. You should only use AI to create a framework for your tests. And understand what you are doing.
contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();
        // Remember when you deploy a new contract, you are the owner of the contract. But, every contract has a unique address.

        // The owner of our token is the address who deploy the contract, which is the msg.sender in this case.
        // msg.sender run deployer.run()!
        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assert(STARTING_BALANCE == ourToken.balanceOf(bob));
    }

    function testAllowance() public {
        // transferFrom: Allow the contract to transfer tokens on your behalf
        // On most application, you need to approve the contract to pull your tokens first
        // Make sure Allowance works

        uint256 initialAllowance = 1000;
        // Bob approves Alice to spend tokens on her behalf
        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        // If you use transfer
        //ourToken.transfer(alice, transferAmount); // whoever is calling this transfer function automatically gets set as the fromAddress

        // ourToken.transferFrom, you can set anybody as the fromAddress but it will only go through if they are approved
        assertEq(ourToken.balanceOf(alice), transferAmount); // as she took it from Bob
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount); // Deduct after Alice transfer
    }

    function testTransfer() public {
        uint256 initialBalance = ourToken.balanceOf(bob);
        uint256 amountToTransfer = 1;
        vm.prank(bob);
        ourToken.transfer(alice, amountToTransfer);

        assertEq(ourToken.balanceOf(bob), initialBalance - amountToTransfer);
        assertEq(ourToken.balanceOf(alice), amountToTransfer);
    }
}
