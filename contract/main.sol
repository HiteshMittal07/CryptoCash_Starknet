// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
import "./verifier.sol";
import "./starknet/IStarknetMessaging.sol" ; 
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract Main is ReentrancyGuard{ 
  // address for starknet core - 0xE2Bb56ee936fd6433DC0F6e7e3b8365C906AA057
    address payable public _owner;
    IStarknetMessaging public  _snMessaging;  
    Groth16Verifier instance; //stores the instance of deployed verifier contract on chain.
    constructor(address starknetCore){ 
        _snMessaging = IStarknetMessaging(starknetCore); 
        Groth16Verifier _instance=new Groth16Verifier(); // deployement of verifier to get instance for further use.
        instance=_instance;
        _owner=payable(msg.sender); //owner is contract creator
    }

    function verify(uint256[2] calldata _pA, uint256[2][2] calldata _pB, uint256[2] calldata _pC, bytes32 _nullifierHash, bytes32 _commitment, address _recipient,uint256 contractAddress,
        uint256 selector,uint256 reciever)external payable{ 
    bool success=instance.verifyProof(_pA, _pB, _pC, [uint256(_nullifierHash),uint256(_commitment),uint256(uint160(_recipient))]);
    require(success,"Invalid Proof");    
       uint256[] memory payload = new uint256[](4);
        payload[0] = uint128(uint256(_nullifierHash)) ;
        payload[1] = uint128(uint256(_nullifierHash) >>128) ; 
        payload[2] = uint128(uint256(_commitment));
        payload[3] = uint128(uint256(_commitment)>>128 );
        payload[4]= uint128(uint256(reciever));
        payload[5]=uint128(uint256(reciever)>>128);

         _snMessaging.sendMessageToL2{value: msg.value}(
            contractAddress,
            selector,
            payload 
        );
    }
}
   