// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;
import {Voter} from "./Voter.sol";

contract Voting_System is Voter {
    uint256 fee = 1 ether;

    constructor(address[3] memory adminAddress) Voter(adminAddress) {}

    function registerAsCandidate() external payable {}

    function changeFee(uint256 _fee) external OnlyAdmins {
        fee = _fee * 1 ether;
    }

    function viewFee() public view returns (uint256) {
        return fee;
    }
}
