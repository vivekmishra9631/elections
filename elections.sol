// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//Building an election smart contract

contract decentralisedElections{
    uint start;
    uint end;
    modifier timeIsOver{
        require(block.timestamp<=end,"Time is up");
        _;
        }

    // Firstly, call this 
    function startTimer() public{
        start=block.timestamp;
        }

     // Secondly, call this 
        // timestamp of the current block in seconds since the epoch
        // period is in seconds
    function endTimer(uint period) public {
        end=period+start;
        }

    function timeLeft() public view returns(uint){
        return end-block.timestamp;
        }

    
    //voters:voted, access to vote, vote Index
    struct Voter{
        bool voted;
        uint vote;
        uint weight;
        string name;
        uint rollNumber;
        string dateofBirth;
        string CGPA;
    }

    struct Candidate{
        string name;  //the name of each candidate
        uint voteCount;  //no of accumulated votes
    
    }

    Candidate[] public candidates;

    mapping(address =>Voter) public voters;    //voters get address as a key and Voter as value

    address public admin;

    //will add prposal names and declare the admin to the smart contract upon deployment 
    constructor() public{
        admin=msg.sender;
        voters[admin].weight=1;
        }

    
    function giveRightToContest(string[] memory candidateNames) public onlyAdmin{
        
        for(uint i=0; i<candidateNames.length; i++){
            candidates.push(Candidate({
                name: candidateNames[i],
                voteCount: 0
            })); 
        }
        
    }

    //function authenticate voter
    function giveRightToVote(address voter) public onlyAdmin{
        
        require(!voters[voter].voted,"your response has already been submitted");
        require(voters[voter].weight==0,"your response has already been submitted");
        voters[voter].weight==1;
        }

    //function for voting
    function giveVote(uint candidate) public timeIsOver{
        Voter storage sender = voters[msg.sender];
        require(sender.weight!=0,"has no right to vote");
        require(!sender.voted,"Already voted");
        sender.voted=true;
        sender.vote=candidate;

        candidates[candidate].voteCount += sender.weight;
        }

    //function for showing the results

    //function which shows result by integer
    function winningCandidate() public view returns(uint winningCandidate_){
        uint winningVoteCount=0;
        for (uint i=0; i<candidates.length; i++) {
             if(winningVoteCount<candidates[i].voteCount){
               winningVoteCount=candidates[i].voteCount;
               winningCandidate_=i;
           }

        }
        


        }

        //function which shows winning proposal by name
        function winningName() public view returns(string memory winningname){
            winningname= candidates[winningCandidate()].name;


        }
        modifier onlyAdmin(){
        require(admin==msg.sender,"only the admin can give the access to vote or contest election");
        _;}

    }





    

