/**
 * This file is autogenerated by Scaffold-ETH.
 * You should not edit it manually or your changes might be overwritten.
 */
import { GenericContractsDeclaration } from "~~/utils/scaffold-eth/contract";

const deployedContracts = {
  84532: {
    FundingPool: {
      address: "0xbf43dd411e901695be7945fa35f8ceee159546d2",
      abi: [
        {
          type: "constructor",
          inputs: [
            {
              name: "_tokenAddress",
              type: "address",
              internalType: "address",
            },
            {
              name: "_ccipRouter",
              type: "address",
              internalType: "address",
            },
            {
              name: "_challengeReceiver",
              type: "address",
              internalType: "address",
            },
            {
              name: "_destinationChain",
              type: "uint64",
              internalType: "uint64",
            },
          ],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "EPOCH_SECONDS",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "ccipRouter",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "challenge",
          inputs: [
            {
              name: "operator",
              type: "address",
              internalType: "address",
            },
            {
              name: "epoch",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "bytes32",
              internalType: "bytes32",
            },
          ],
          stateMutability: "payable",
        },
        {
          type: "function",
          name: "challengeReceiver",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "charToken",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "contract IBiochar",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "contribute",
          inputs: [
            {
              name: "_from",
              type: "address",
              internalType: "address",
            },
            {
              name: "_value",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "_operator",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "contributions",
          inputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "destinationChain",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "uint64",
              internalType: "uint64",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "retire",
          inputs: [
            {
              name: "tco2s",
              type: "address[]",
              internalType: "address[]",
            },
            {
              name: "amounts",
              type: "uint256[]",
              internalType: "uint256[]",
            },
            {
              name: "maxFee",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "error",
          name: "NotEnoughBalance",
          inputs: [
            {
              name: "currentBalance",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "calculatedFees",
              type: "uint256",
              internalType: "uint256",
            },
          ],
        },
      ],
      inheritedFunctions: {},
    },
  },
} as const;

export default deployedContracts satisfies GenericContractsDeclaration;
