pragma solidity 0.4.11;
import "./HumanStandardToken.sol";

contract PresedentialElection {
    address public owner;
    uint public electionEnd;
    mapping (address => uint) public votes;
    address public winner;
    bool public tie;
    HumanStandardToken public citizenshipToken;
    
    function PresedentialElection(uint lengthOfElectionInSeconds, uint numberOfCitizens) {
        owner = msg.sender;
        electionEnd = now + lengthOfElectionInSeconds;
        
        citizenshipToken = new HumanStandardToken(numberOfCitizens,"",0,"");
    }
    
    function giveCitizenship(address to) {
        require(msg.sender==owner);
        require(citizenshipToken.balanceOf(to)==0);
        require(citizenshipToken.allowance(to,this)>=1);
        
        citizenshipToken.transfer(to, 1);
    }
    
    function vote(address candidate) {
        require(now<electionEnd);
        require(citizenshipToken.balanceOf(msg.sender)>=1);
        
        votes[candidate]++;
        
        if(votes[candidate]>votes[winner]) {
            winner = candidate;
        } else if(votes[candidate]==votes[winner]) {
            tie = true;
            winner = 0x0;
        }
        
        citizenshipToken.transferFrom(msg.sender, citizenshipToken, 1);
    }
    
    function() {}
}