pragma solidity ^0.8.0;

contract BuyThis {
    address public owner; // Current owner of the token.
    string public ipfsImgHash; // Current image hash.
    uint256 public cost; // Current cost of ownership. Increases by 2x every time ownership is transferred.

    constructor() {
	owner = msg.sender;
	ipfsImgHash = "QmdCDJLHfAUxW65f5tmtmUvjQQP9rTWcqWHibmmb9E72My";
	cost = 1;
    }

    // Take ownership from the current owner.
    // @param newIpfsImgHash: New hash to set the image to.
    function buy(string memory newIpfsImgHash) payable public {
	// Someone cannot transfer ownership to themselves.
	require(msg.sender != owner, "Owner cannot purchase from themselves.");

	// Transfer eth from sender to contract.
	require(msg.value == cost, "Insufficient funds provided. Must pay current cost.");

	// Transfer eth from contract to previous owner.
	(bool success, ) = owner.call{value:cost}("");
	require(success, "Transfer of funds to previous owner failed.");

	// Finalize transfer of ownership to new owner.
	owner = msg.sender;
	ipfsImgHash = newIpfsImgHash;
	cost *= 2;
    }
}
