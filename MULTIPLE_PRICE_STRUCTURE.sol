// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// @dev: this is an example contract for maintining a fixed set of prices
// within a mapping of "price tiers".
// This can be useful if you want to allow people to direclty mint different tiers,
// or when you want the Dapp to have control over which tier, when.
contract NFT  is ERC721('MULTI', 'MTI') {
    
    uint256 mintedTokens = 0;
    mapping(string => uint256) public priceStructure;
    
    constructor() {
        priceStructure['common'] = 0.05 ether;
        priceStructure['rare'] = 0.1 ether;
        priceStructure['UltraRare'] = 0.25 ether;
    }
    
    function mint(string memory _tier, uint256 _quantity) public payable{
        uint256 price = priceStructure[_tier];
        require(_quantity * price <= msg.value, "Not enough minerals");

        // Add additional requirements as needed
        for (uint256 i = 0; i < _quantity; i++) {
            // GIFT_SUPPLY should start from token ID 1, while public supply starts after
            uint256 tokenID = mintedTokens + 1;
            _safeMint(msg.sender, tokenID);
            mintedTokens += 1;
        }
    }
}
