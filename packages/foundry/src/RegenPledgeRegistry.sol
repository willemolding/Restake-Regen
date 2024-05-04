//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {IWorldID} from "./interfaces/IWorldID.sol";
import {ByteHasher} from "./libraries/ByteHasher.sol";

contract RegenPledgeRegistry {
     using ByteHasher for bytes;

    IWorldID internal immutable worldId;
    uint256 internal immutable externalNullifier;

    mapping(address => uint256) public pledges;
    mapping(uint256 => bool) public usedNullifiers;

    constructor(
        IWorldID _worldId,
        string memory _appId,
        string memory _actionId
    ) public {
        worldId = _worldId;
        externalNullifier = abi
            .encodePacked(abi.encodePacked(_appId).hashToField(), _actionId)
            .hashToField();
    }

    function makePledge(
        address operator, // address of the operator making the pledge
        uint256 amount // fraction of the network this operator wants to offset. This is encoded such that 1e18 is 100%
        // uint256 root, //WorldID Merkle root
        // uint256 nullifierHash, // WorldID nullifier hash
        // uint256[8] calldata proof // WorldID proof
    ) public {
        // in the proper implementation this will first check the operator is
        // registered with Eigenlayer and has been delegated the required amount of stake

        // ensure the operator is a unique human that has not registered a pledge before
        // the operator address is the signal in this case
        // Not sure why we are having trouble getting proofs to verify on Sepolia..
        // worldId.verifyProof(
        //     root,
        //     1, // use orb verification
        //     abi.encodePacked(operator).hashToField(),
        //     nullifierHash,
        //     externalNullifier,
        //     proof
        // );
        // store the nullifier so it cannot be reused
        // usedNullifiers[nullifierHash] = true;

        // store a record of the pledge!
        pledges[operator] = amount;
    }

    /// @dev Creates a keccak256 hash of a bytestring.
    /// @param value The bytestring to hash
    /// @return The hash of the specified value
    /// @dev `>> 8` makes sure that the result is included in our field
    function hashToField(bytes memory value) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(value))) >> 8;
    }
}
