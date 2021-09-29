// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PriceIncrease {
    
    // @dev starting the pricelist tier from 0 index
    int public priceTier = 0;
    uint256 public totalPurchased = 0;
    
    struct price {
        uint256 value;
        uint256 limit;
    }
    
    mapping(int => price) public pricelist;
    
    constructor() {
        // Manually define pricelist tiers
        // @dev, this could be extracted to a function
        pricelist[0] = price({value: 0.05 ether, limit: 3});
        pricelist[1] = price({value: 0.06 ether, limit: 5});
        pricelist[2] = price({value: 0.07 ether, limit: 10});
        
        // @dev, you could also define this in shorthand
        pricelist[3] = price(0.08 ether, 40);
    }
    
    function purchase(uint256 _purchaseQuantity) public payable{
        
        // @dev we want to check once for every purchased token which price to use
        for(uint256 i = 0; i < _purchaseQuantity; i++) {
            
            uint256 currentLimit = pricelist[priceTier].limit;
            
            //in the event someone purchases enough to go to the next tier
            if(totalPurchased  + 1 > currentLimit) {
                
                // increase the global price tier to the next tier.
                // @dev TODO: there should be a guard againt going _over_ the last tier
                priceTier += 1;
            }
            
            uint256 currentPrice = pricelist[priceTier].value;
            require(msg.value >= currentPrice, "Insufficient funds");
            
            // Implement Mint here
            totalPurchased += 1;
        }
    }

}
