pragma solidity 0.4.11;
import "./HumanStandardToken.sol";

contract PresedentialElection {
    address public owner;
    uint public electionEnd;
    address[] public candidates;
    mapping (address => uint) public votes;
    address public winner;
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
        
        candidates.push(candidate);
        votes[candidate]++;
        
        citizenshipToken.transferFrom(msg.sender, citizenshipToken, 1);
    }
    
    function checkWinner() returns (address) {
        //require(now>=electionEnd);
        
        uint mostVotes = 0;
        for(uint i=0;i<candidates.length;i++) {
            address c = candidates[i];
            if(votes[c]>mostVotes) {
                winner = c;
            }
        }
        
        return c;
    }
    
    function() {}
}