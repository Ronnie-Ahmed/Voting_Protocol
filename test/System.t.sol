// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;
import {Test, console2} from "forge-std/Test.sol";
import {Voting_System} from "../src/Voting_System.sol";
import {Voter} from "../src/Voter.sol";

contract VotingTest is Test {
    Voter public voter;

    // Voting_System public voting_system;

    function setUp() external {
        voter = new Voter([address(1), address(2), address(3)]);
    }

    function testAdmins() external {
        (
            address administrator1,
            address administrator2,
            address councilPresident
        ) = voter.viewAdmins();
        assertEq(administrator1, address(1));
        assertEq(administrator2, address(2));
        assertEq(councilPresident, address(3));
    }

    function testchangeAdministrator() external {
        (, , address councilPresident) = voter.viewAdmins();
        vm.prank(councilPresident);

        bool success = voter.changeAdministrator(address(4), address(5));
        assertEq(success, true);
        vm.expectRevert();
        bool testSuccess = voter.changeAdministrator(address(1), address(2));
        assertEq(testSuccess, false);
    }
}
