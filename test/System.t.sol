// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;
import {Test, console2} from "forge-std/Test.sol";
import {Voter} from "../src/Voter.sol";

contract VotingTest is Test {
    Voter public voter;

    function setUp() external {
        voter = new Voter(address(1), address(2), address(3));
        // voting_system = new Voting_System([address(1), address(2), address(3)]);
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

    function registerNID() public returns (bytes32 _nid) {
        _nid = voter.getMyNID("A", "B", "C", false, 1220, 1999, 8, 9);
    }

    function registerVoter() public returns (bytes32 _voterId) {
        bytes32 nid = registerNID();
        Voter.NIDinfo memory tempNid = voter.viewMyInfo(nid);
        voter.registerAsVoter(tempNid.areaCode);
        _voterId = voter.getMyVOTERID();
    }

    function testNID() external {
        vm.startPrank(address(8));
        bytes32 nid = registerNID();
        bytes32 testNid = voter.viewMyNID();
        assertEq(nid, testNid);
    }

    function testNIDStruct() external {
        vm.startPrank(address(8));
        bytes32 nid = registerNID();
        Voter.NIDinfo memory tempNid = voter.viewMyInfo(nid);
        vm.stopPrank();
        assertEq(tempNid._name, "A");
        assertEq(tempNid.fatherName, "C");
        assertEq(tempNid.motherName, "B");
        assertEq(tempNid.isMarried, false);
        assertEq(tempNid.myWalletAddress, address(8));
        assertEq(tempNid.myNID, nid);
        assertEq(tempNid.areaCode, 1220);
    }

    function testRegisterVoter() external {
        vm.startPrank(address(8));
        bytes32 VOTERID = registerVoter();
        bytes32 testID = voter.getMyVOTERID();
        assertEq(testID, VOTERID);
    }

    function testVoterStruct() external {
        vm.startPrank(address(8));
        bytes32 _ID = registerVoter();
        Voter.VoterINfo memory tempInfo = voter.viewMyVoterInfo();
        assertEq(tempInfo.myWalletAddress, address(8));
        assertEq(tempInfo._voterID, _ID);
        assertEq(tempInfo.areaCode, 1220);
        assertEq(tempInfo.myNID, voter.viewMyNID());
        vm.stopPrank();
    }

    function testLastBirthYear() external {
        (address administrator1, , ) = voter.viewAdmins();
        vm.startPrank(administrator1);
        uint256 year = 2000;
        voter.changeLEastBirthYear(year);
        uint256 testYear = voter.viewLeastBirthYear();
        assertEq(testYear, year);
        vm.expectRevert();
        voter.changeLEastBirthYear(2001);
        vm.stopPrank();
    }

    function testLastBirthYearRevert() external {
        uint256 year = 2000;
        vm.expectRevert();
        voter.changeLEastBirthYear(year);
    }

    function testMyIDRevert() external {
        vm.expectRevert();
        voter.viewMyNID();
    }

    function testgetMyVOTERIDRevert() external {
        vm.expectRevert();
        voter.getMyVOTERID();
    }

    function testFee() external {
        (address administrator, , ) = voter.viewAdmins();
        vm.startPrank(administrator);
        uint256 _fee = voter.viewFee();
        assertEq(_fee, 1 ether);
        voter.changeFee(2);
        uint256 __fee = voter.viewFee();
        assertEq(__fee, 2 ether);
        // vm.stopPrank();
    }

    function testfeeRevert() external {
        vm.expectRevert();
        voter.changeFee(2);
    }

    function testRegisterAsCandidate() external {
        vm.startPrank(address(11));
        deal(address(11), 10 ether);
        registerVoter();
        voter.registerAsCandidate{value: 1 ether}();
        Voter.Candidate memory tempCandidate = voter.viewCandidateInfo();
        assertEq(tempCandidate.isACandidate, true);
    }

    function testviewCurrentProgress() external {
        string memory _state = voter.viewCurrentProgress();
        assertEq(_state, "Completed");
    }

    function teststartElection() external {
        (
            address administrator1,
            address administrator2,
            address councilPresident
        ) = voter.viewAdmins();
        vm.prank(administrator1);
        voter.preposeElection();
        uint256 id = voter.viewElectionNumber();
        vm.prank(councilPresident);
        voter.approve(id);
        uint256 start = block.timestamp;
        vm.warp(start + 1 days);
        vm.prank(administrator2);
        string memory message = voter.startEletion(id);
        assertEq(message, "Election Started");
    }

    function _startElection() public returns (address) {
        (
            address administrator1,
            address administrator2,
            address councilPresident
        ) = voter.viewAdmins();
        vm.prank(administrator1);
        voter.preposeElection();
        uint256 id = voter.viewElectionNumber();
        vm.prank(councilPresident);
        voter.approve(id);
        return administrator2;
    }

    function candidate() public {
        registerVoter();
        voter.registerAsCandidate{value: 1 ether}();
    }

    function testCandidate() external {
        uint256 start = block.timestamp;
        address admin = _startElection();
        vm.startPrank(address(10));
        deal(address(10), 10 ether);
        candidate();
        uint256 id = voter.viewElectionNumber();
        voter.joinAsCandidate(id);
        vm.stopPrank();
        vm.warp(start + 1 days);
        vm.prank(admin);
        string memory message = voter.startEletion(id);
        assertEq(message, "Election Started");
    }
}
