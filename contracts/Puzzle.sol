pragma solidity >=0.4.22 <0.7.0;
pragma experimental ABIEncoderV2;

contract Puzzle {
    string private flag = "";
    string public name = "name";
    address public Owner;
    uint256 start;
    uint256 timer;
    uint256 deadline;
    struct Attender{
        address addr;
        string name;
        string flag;
    }
    Attender[] public Attenders;
    
    modifier isTimeout(){
        require(now >= deadline); _;
    }
    constructor (string memory _flag, string memory _name, uint256 _timer) public {
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
    
    function ShowFlag() public view isTimeout() returns(string memory) {
        return flag;
    }
    
    function Attend(string memory _name, string memory _flag) public {
        Attenders.push(Attender(
            {name: _name,
            addr: msg.sender,
            flag: _flag}
            ));
    }
    
    function Whowin() public view isTimeout returns(string [10] memory) {
        string[10] memory winners;
        for (uint i = 0; i < winners.length; i++)
            winners[i] = "X";
        uint k = 0;
        for (uint i = 0; i < Attenders.length; i++) {
            if (keccak256(abi.encodePacked((Attenders[i].flag))) == keccak256(abi.encodePacked((flag))))
                winners[k++] = Attenders[i].name;
        }
        
        return winners;
    }
}
