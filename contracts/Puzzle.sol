pragma solidity >=0.4.22 <0.7.0;
// pragma experimental ABIEncoderV2;

contract Puzzle {
    bytes private flag = "";
    bytes public name = "name";
    address public Owner;
    uint256 start;
    uint256 timer;
    uint256 deadline;
    struct Attender{
        address addr;
        bytes name;
        bytes flag;
        uint256 time;
    }
    Attender[] public Attenders;
    
    modifier isTimeout(){
        require(now >= deadline); _;
    }

    constructor (bytes memory _flag, bytes memory _name, uint256 _timer) public {
        flag = _flag;
        name = _name;
        Owner = msg.sender;
        start = now;
        timer = _timer;
        deadline = start + timer;
    }

    function ShowTime() public view returns(uint256) {
        return start;
    }

    function ShowFlag() public view isTimeout() returns(bytes memory) {
        return flag;
    }

    function Attend(bytes memory _name, bytes memory _flag) public {
        Attenders.push(Attender(
            {name: _name,
            addr: msg.sender,
            flag: _flag,
            time: now
            }
            ));
    }
    
    function Compare(bytes memory s1, bytes memory s2) private pure returns(bool) {
        for(uint i = 0; i < s1.length; i++)
            if(s1[i] != s2[i])
                return false;
        return true;
    }

    function Whowin() public view isTimeout returns(address, bytes memory) {
        
        address winner_address;
        bytes memory winner_name;
        uint256 winner_time =  2**256 - 1;

        for (uint i = 0; i < Attenders.length; i++) {
            //if (keccak256(abi.encodePacked((Attenders[i].flag))) == keccak256(abi.encodePacked((flag))))
            if(Compare(flag, Attenders[i].flag) && winner_time > Attenders[i].time) {
                winner_name = Attenders[i].name;
                winner_address = Attenders[i].addr;
                winner_time =Attenders[i].time;
            }
        }
        
        return (winner_address, winner_name);
    }
}