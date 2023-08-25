// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract SeedSpark {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => Campaign) public campaigns;

    uint256 public numberOfCampaigns = 0;

    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future.");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;  // index of this campaign
    }

    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value; // this is the amount that we are trying to send from our frontend.

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);  // [ushing the address of the person that donated.
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");  //payable returns two different things and right now we are accessing just one, thats why the ',' to let solidity know something else might come after that as well.

        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }


    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory){ //the parameters are the address of the donators and the number of donations  
        return (campaigns[_id].donators, campaigns[_id].donations);
    }


    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);  // crating a new variable allCampaigns of type array of multiple campaign structs . We are just creating an empty array with just as many elements as there are actual campaigns.

        for(uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }

        return allCampaigns;
    }

}