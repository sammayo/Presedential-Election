pragma solidity 0.4.11;
import "./HumanStandardToken.sol";

contract PresedentialElection {
    address public owner;
    uint public electionEnd;
    mapping (address => uint) public votes;
    address public winner;
    uint public winnerVotes;
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
        
        if(candidate==winner) {
            winnerVotes++;
        }
        
        if(votes[candidate]>winnerVotes) {
            winner = candidate;
            winnerVotes = votes[candidate];
        }
        
        citizenshipToken.transferFrom(msg.sender, citizenshipToken, 1);
    }
    
    function() {}
}