// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

// import {Voter} from "./Voter.sol";

contract Voting_System {

}

// contract Voting_System is Voter {
//     uint256 fee = 1 ether;

//     modifier LeastAmount() {
//         require(msg.value == fee, "Need to give Right Amount of Fee");
//         _;
//     }

//     modifier OnlyCandidate() {
//         require(
//             candidateInfo[msg.sender].isACandidate,
//             "Only Voting Candidate Can Access this"
//         );
//         _;
//     }

//     struct Candidate {
//         string _name;
//         address _address;
//         uint256 _areaCode;
//         bytes32 _voterId;
//         bytes32 _Nid;
//         bool isACandidate;
//     }

//     mapping(address => Candidate) candidateInfo;

//     constructor(address[3] memory adminAddress) Voter(adminAddress) {}

//     function registerAsCandidate()
//         external
//         payable
//         OnlyVoter
//         OnlyNIDHolder
//         LeastAmount
//     {
//         bytes32 Nid = Voter.viewMyNID();
//         bytes32 VoterId = Voter.getMyVOTERID();
//         VoterINfo memory temp = Voter.viewMyVoterInfo();
//         NIDinfo memory tempNid = Voter.viewMyInfo(Nid);
//         uint256 _areaCode = temp.areaCode;
//         string memory _name = tempNid._name;
//         candidateInfo[msg.sender] = Candidate(
//             _name,
//             msg.sender,
//             _areaCode,
//             VoterId,
//             Nid,
//             true
//         );
//     }

//     function changeFee(uint256 _fee) external OnlyAdmins {
//         fee = _fee * 1 ether;
//     }

//     function viewFee() public view returns (uint256) {
//         return fee;
//     }

//     function viewCandidateInfo()
//         public
//         view
//         OnlyCandidate
//         returns (Candidate memory)
//     {
//         return candidateInfo[msg.sender];
//     }
// }
