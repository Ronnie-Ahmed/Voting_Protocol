// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;
import {Voter} from "./Voter.sol";

contract Voting_System {
    address immutable administrator1;
    address immutable administrator2;
    address immutable councilPresident;
    Voter immutable voter;

    constructor(address _voter) {
        voter = Voter(_voter);
        (administrator1, administrator2, councilPresident) = voter.viewAdmins();
    }
}
