// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;
import {Test, console2} from "forge-std/Test.sol";

contract Voter {
    error ErrorAdministratorAssign();

    address administrator1;
    address administrator2;
    address councilPresident;

    mapping(address => bool) isAdminUnique;

    modifier OnlyPresident() {
        require(
            msg.sender == councilPresident,
            "Only Council President Have the access of this feature"
        );
        _;
    }

    constructor(address[3] memory adminAddress) {
        for (uint256 i = 0; i < 3; i++) {
            if (
                isAdminUnique[adminAddress[i]] == true ||
                adminAddress[i] == address(0)
            ) {
                revert ErrorAdministratorAssign();
            }
            isAdminUnique[adminAddress[i]] = true;
        }
        administrator1 = adminAddress[0];
        administrator2 = adminAddress[1];
        councilPresident = adminAddress[2];
    }

    function changeAdministrator(
        address _administrator1,
        address _administrator2
    ) external OnlyPresident returns (bool isSuccess) {
        administrator1 = _administrator1;
        administrator2 = _administrator2;
        isSuccess = true;
    }

    function viewAdmins()
        public
        view
        returns (
            address _administrator1,
            address _administrator2,
            address _councilPresident
        )
    {
        _administrator1 = administrator1;
        _administrator2 = administrator2;
        _councilPresident = councilPresident;
    }
}
