// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract Voter {
    error ErrorAdministratorAssign();
    error ErrorInputingBIrthYear();
    error InvalidInput();

    address administrator1;
    address administrator2;
    address councilPresident;
    uint256 leastBirthYear = 2005;

    // struct VoterInfo {
    //     string voterId;
    //     string Name;
    //     uint256 areaCode;

    // }
    struct NIDinfo {
        string _name;
        string fatherName;
        string motherName;
        bool isMarried;
        address myWalletAddress;
        bytes32 myNID;
    }

    mapping(address => bool) isAdminUnique;
    mapping(address => bytes32) myNID;
    mapping(address => bool) didIGetMyNID;
    mapping(bytes32 => NIDinfo) getMyNIDinfo;

    modifier OnlyPresident() {
        require(
            msg.sender == councilPresident,
            "Only Council President Have the access of this feature"
        );
        _;
    }

    modifier OnlyAdmins() {
        require(
            msg.sender == administrator1 || msg.sender == administrator2,
            "Only Administrator can Access This Features"
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

    function changeLEastBirthYear(uint256 _newYear) external OnlyAdmins {
        if (_newYear < leastBirthYear) {
            revert ErrorInputingBIrthYear();
        }
        leastBirthYear = _newYear;
    }

    function changeAdministrator(
        address _administrator1,
        address _administrator2
    ) external OnlyPresident returns (bool isSuccess) {
        if (
            isAdminUnique[_administrator1] == true ||
            _administrator1 == address(0) ||
            _administrator2 == address(0) ||
            isAdminUnique[_administrator1] == true
        ) {
            revert ErrorAdministratorAssign();
        }

        administrator1 = _administrator1;
        administrator2 = _administrator2;
        isSuccess = true;
    }

    function getMyNID(
        string memory _name,
        string memory _mothername,
        string memory _fathername,
        bool isMarried,
        uint256 _areaCode,
        uint256 birthYear,
        uint256 birthMonth,
        uint256 birthday
    ) external returns (bytes32 NID) {
        if (birthMonth > 12 || birthMonth < 0 || birthYear > leastBirthYear) {
            revert InvalidInput();
        }
        require(!didIGetMyNID[msg.sender], "I am Alreay a voter");

        uint256 _date = checkValidMonth(birthMonth, birthYear);
        require(birthday <= _date, "INvalid Date INput");
        NID = keccak256(
            abi.encodePacked(
                _name,
                _areaCode,
                birthYear,
                birthMonth,
                birthday,
                _mothername,
                _fathername,
                isMarried,
                block.timestamp,
                blockhash(block.number - 1)
            )
        );
        myNID[msg.sender] = NID;
        didIGetMyNID[msg.sender] = true;
        getMyNIDinfo[NID] = NIDinfo(
            _name,
            _fathername,
            _mothername,
            isMarried,
            msg.sender,
            NID
        );
    }

    function isLeapYear(uint256 year) internal pure returns (bool) {
        if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
            return true;
        } else {
            return false;
        }
    }

    function checkValidMonth(
        uint256 _month,
        uint256 _year
    ) internal pure returns (uint256 date) {
        bool _isLeapYear = isLeapYear(_year);
        assembly {
            switch _month
            case 1 {
                date := 31
            }
            case 3 {
                date := 31
            }
            case 5 {
                date := 31
            }
            case 7 {
                date := 31
            }
            case 8 {
                date := 31
            }
            case 10 {
                date := 31
            }
            case 12 {
                date := 31
            }
            case 4 {
                date := 30
            }
            case 6 {
                date := 30
            }
            case 9 {
                date := 30
            }
            case 11 {
                date := 30
            }
            case 2 {
                switch _isLeapYear
                case 1 {
                    date := 29
                }
                default {
                    date := 28
                }
            }
            default {
                date := 0 // Invalid month
            }
        }
    }

    function viewMyNID() public view returns (bytes32) {
        return myNID[msg.sender];
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
