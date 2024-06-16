// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
import "./verifier.sol";
import "./starknet/IStarknetMessaging.sol" ; 
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract Main is ReentrancyGuard{ 
    address payable public _owner;
    IStarknetMessaging public  _snMessaging;  
    Groth16Verifier instance; //stores the instance of deployed verifier contract on chain.
    constructor(address starknetCore){ 
        _snMessaging = IStarknetMessaging(starknetCore); 
        Groth16Verifier _instance=new Groth16Verifier(); // deployement of verifier to get instance for further use.
        instance=_instance;
        _owner=payable(msg.sender); //owner is contract creator
    }

    function verify(uint256[2] calldata _pA, uint256[2][2] calldata _pB, uint256[2] calldata _pC, bytes32 _nullifierHash, bytes32 _commitment, address _recipient)view public returns(bool) { 
    bool success=instance.verifyProof(_pA, _pB, _pC, [uint256(_nullifierHash),uint256(_commitment),uint256(uint160(_recipient))]);
    require(success,"Invalid Proof");    
    return success;
  }
   function sendMessageValue(
        uint256 contractAddress,
        uint256 selector
    )
        external
        payable
    {
        uint256[] memory payload = new uint256[](1);
        payload[0] = 1 ;

        _snMessaging.sendMessageToL2{value: msg.value}(
            contractAddress,
            selector,
            payload
        );
    }
}