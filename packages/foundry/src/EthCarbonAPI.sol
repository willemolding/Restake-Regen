// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {Chainlink, ChainlinkClient} from "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import {ConfirmedOwner} from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";



// REQUEST AS PER https://docs.chain.link/any-api/get-request/examples/array-response#example
// https://docs.chain.link/any-api/api-reference#chainlinkrequest

function requestEmissionsData() public returns (bytes32 requestId) {
    Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

    // Set the URL to the API endpoint
    req.add("get", "https://ccaf.io/cbeci/api/eth/pos/charts/total_greenhouse_gas_emissions/monthly");

    // Hope this works????
    req.add("path", "data,28,y");

    // Multiply the result by 1000 to convert from kilo tonnes to tonnes
    req.addInt("times", 1000);

    // Sends the request
    return sendChainlinkRequestTo(oracle, req, fee);
}

