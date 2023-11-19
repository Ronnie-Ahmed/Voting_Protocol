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

    struct NIDinfo {
        string _name;
        string fatherName;
        string motherName;
        bool isMarried;
        address myWalletAddress;
        bytes32 myNID;
        uint256 areaCode;
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
                blockhash(block.number)
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
            NID,
            _areaCode
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

        if (
            _month == 1 ||
            _month == 3 ||
            _month == 5 ||
            _month == 7 ||
            _month == 8 ||
            _month == 10 ||
            _year == 12
        ) {
            date = 31;
        } else if (_month == 4 || _month == 6 || _month == 9 || _month == 11) {
            date = 30;
        } else if (_month == 2) {
            if (_isLeapYear) {
                date = 29;
            } else {
                date = 28;
            }
        } else {
            date = 0;
        }
    }

    function viewMyNID() public view returns (bytes32) {
        return myNID[msg.sender];
    }

    function viewMyInfo(bytes32 _NID) public view returns (NIDinfo memory) {
        return getMyNIDinfo[_NID];
    }

    function viewLeastBirthYear() external view returns (uint256) {
        return leastBirthYear;
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
