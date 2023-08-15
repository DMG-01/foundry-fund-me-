//SPDX-License-Identifier:MIT

pragma solidity 0.8.19;

import { Script }  from "forge-std/Script.sol";
import { MockV3Aggregator } from "test/integration/mockv3Aggregator/mockV3Aggregator.sol";

contract HelperConfig  is Script{

   networkConfig public activeNetworkConfig;

   constructor(){
    if(block.chainid == 11155111 ){
       activeNetworkConfig = getSepoliaHelpConfig();
    }
    else  {
        activeNetworkConfig = getOrCreateAnvilHelpConfig() ;
    }
    
   }
    struct networkConfig{
        address priceFeed;
    }

    function getSepoliaHelpConfig() public pure returns(networkConfig memory)  {
    networkConfig memory sepoliaConfig = networkConfig({
       priceFeed : 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilHelpConfig() public returns(networkConfig memory){
if(activeNetworkConfig.priceFeed != address(0)) {
    return activeNetworkConfig;
}

vm.startBroadcast();
MockV3Aggregator mockPriceFeed =  new MockV3Aggregator(8, 2000e8);
vm.stopBroadcast();

networkConfig memory anvilConfig = networkConfig({
    priceFeed : address(mockPriceFeed)
});
return anvilConfig;
    }
}