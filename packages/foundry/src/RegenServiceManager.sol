//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@eigenlayer-middleware/src/ServiceManagerBase.sol";

contract RegenServiceManager is ServiceManagerBase {
    constructor(
        IAVSDirectory _avsDirectory,
        IRegistryCoordinator _registryCoordinator,
        IStakeRegistry _stakeRegistry
    )
        ServiceManagerBase(
            _avsDirectory,
            IPaymentCoordinator(address(0)), // inc-sq doesn't need to deal with payments
            _registryCoordinator,
            _stakeRegistry
        )
    {
    }
}
