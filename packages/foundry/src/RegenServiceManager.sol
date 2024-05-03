//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@eigenlayer-middleware/src/ServiceManagerBase.sol";
import {RegenChallengeManager} from "./RegenChallengeManager.sol";

contract RegenServiceManager is ServiceManagerBase {
    RegenChallengeManager public immutable challengeManager;

    /// @notice when applied to a function, ensures that the function is only callable by the `challengeManger` contract.
    modifier onlyRegenChallengeManager() {
        require(
            msg.sender == address(challengeManager),
            "Not callable by anything other than the registered challenge manager contract"
        );
        _;
    }

    constructor(
        IAVSDirectory _avsDirectory,
        IRegistryCoordinator _registryCoordinator,
        IStakeRegistry _stakeRegistry,
        RegenChallengeManager _challengeManager
    )
        ServiceManagerBase(
            _avsDirectory,
            IPaymentCoordinator(address(0)), // restake-regen doesn't need to deal with payments
            _registryCoordinator,
            _stakeRegistry
        )
    {
        challengeManager = _challengeManager;
    }


    /// @notice Called by the ChallengeManager to freeze an operator.
    /// @dev The Slasher contract is under active development and its interface expected to change.
    ///      We recommend writing slashing logic without integrating with the Slasher at this point in time.
    function freezeOperator(
        address operatorAddr
    ) external onlyRegenChallengeManager {
        // slasher.freezeOperator(operatorAddr);
    }
}
