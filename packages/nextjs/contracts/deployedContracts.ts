/**
 * This file is autogenerated by Scaffold-ETH.
 * You should not edit it manually or your changes might be overwritten.
 */
import { GenericContractsDeclaration } from "~~/utils/scaffold-eth/contract";

const deployedContracts = {
  31337: {
    RegenPledgeRegistry: {
      address: "0x5fbdb2315678afecb367f032d93f642f64180aa3",
      abi: [
        {
          type: "function",
          name: "makePledge",
          inputs: [
            {
              name: "operator",
              type: "address",
              internalType: "address",
            },
            {
              name: "amount",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "pledges",
          inputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
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
      ],
      inheritedFunctions: {},
    },
    RegenChallengeManager: {
      address: "0xe7f1725e7734ce288f8367e1bb143e90bb3f0512",
      abi: [
        {
          type: "constructor",
          inputs: [
            {
              name: "_router",
              type: "address",
              internalType: "address",
            },
            {
              name: "_pledgeRegistry",
              type: "address",
              internalType: "contract RegenPledgeRegistry",
            },
          ],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "ccipReceive",
          inputs: [
            {
              name: "message",
              type: "tuple",
              internalType: "struct Client.Any2EVMMessage",
              components: [
                {
                  name: "messageId",
                  type: "bytes32",
                  internalType: "bytes32",
                },
                {
                  name: "sourceChainSelector",
                  type: "uint64",
                  internalType: "uint64",
                },
                {
                  name: "sender",
                  type: "bytes",
                  internalType: "bytes",
                },
                {
                  name: "data",
                  type: "bytes",
                  internalType: "bytes",
                },
                {
                  name: "destTokenAmounts",
                  type: "tuple[]",
                  internalType: "struct Client.EVMTokenAmount[]",
                  components: [
                    {
                      name: "token",
                      type: "address",
                      internalType: "address",
                    },
                    {
                      name: "amount",
                      type: "uint256",
                      internalType: "uint256",
                    },
                  ],
                },
              ],
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "getRouter",
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
          name: "initialize",
          inputs: [
            {
              name: "_serviceManager",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "pledgeRegistry",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "contract RegenPledgeRegistry",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "serviceManager",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "contract RegenServiceManager",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "supportsInterface",
          inputs: [
            {
              name: "interfaceId",
              type: "bytes4",
              internalType: "bytes4",
            },
          ],
          outputs: [
            {
              name: "",
              type: "bool",
              internalType: "bool",
            },
          ],
          stateMutability: "pure",
        },
        {
          type: "error",
          name: "InvalidRouter",
          inputs: [
            {
              name: "router",
              type: "address",
              internalType: "address",
            },
          ],
        },
      ],
      inheritedFunctions: {},
    },
    RegenServiceManager: {
      address: "0x9fe46736679d2d9a65f0992f2272de9f3c7fa6e0",
      abi: [
        {
          type: "constructor",
          inputs: [
            {
              name: "_challengeManager",
              type: "address",
              internalType: "contract RegenChallengeManager",
            },
          ],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "challengeManager",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "contract RegenChallengeManager",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "freezeOperator",
          inputs: [
            {
              name: "operatorAddr",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
      ],
      inheritedFunctions: {},
    },
  },
  11155111: {
    RegenPledgeRegistry: {
      address: "0xa850e0c22df9b3175fddb3123b6adf2e6af75dce",
      abi: [
        {
          type: "function",
          name: "makePledge",
          inputs: [
            {
              name: "operator",
              type: "address",
              internalType: "address",
            },
            {
              name: "amount",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "pledges",
          inputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
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
      ],
      inheritedFunctions: {},
    },
    RegenChallengeManager: {
      address: "0x519aded431cdd0701cb64055bcfe4edd828da007",
      abi: [
        {
          type: "constructor",
          inputs: [
            {
              name: "_router",
              type: "address",
              internalType: "address",
            },
            {
              name: "_pledgeRegistry",
              type: "address",
              internalType: "contract RegenPledgeRegistry",
            },
          ],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "ccipReceive",
          inputs: [
            {
              name: "message",
              type: "tuple",
              internalType: "struct Client.Any2EVMMessage",
              components: [
                {
                  name: "messageId",
                  type: "bytes32",
                  internalType: "bytes32",
                },
                {
                  name: "sourceChainSelector",
                  type: "uint64",
                  internalType: "uint64",
                },
                {
                  name: "sender",
                  type: "bytes",
                  internalType: "bytes",
                },
                {
                  name: "data",
                  type: "bytes",
                  internalType: "bytes",
                },
                {
                  name: "destTokenAmounts",
                  type: "tuple[]",
                  internalType: "struct Client.EVMTokenAmount[]",
                  components: [
                    {
                      name: "token",
                      type: "address",
                      internalType: "address",
                    },
                    {
                      name: "amount",
                      type: "uint256",
                      internalType: "uint256",
                    },
                  ],
                },
              ],
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "getRouter",
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
          name: "initialize",
          inputs: [
            {
              name: "_serviceManager",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "pledgeRegistry",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "contract RegenPledgeRegistry",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "serviceManager",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "contract RegenServiceManager",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "supportsInterface",
          inputs: [
            {
              name: "interfaceId",
              type: "bytes4",
              internalType: "bytes4",
            },
          ],
          outputs: [
            {
              name: "",
              type: "bool",
              internalType: "bool",
            },
          ],
          stateMutability: "pure",
        },
        {
          type: "error",
          name: "InvalidRouter",
          inputs: [
            {
              name: "router",
              type: "address",
              internalType: "address",
            },
          ],
        },
      ],
      inheritedFunctions: {},
    },
    RegenServiceManager: {
      address: "0xe8433e58e348675568c0d7fcdd1af0a6d5d5f6aa",
      abi: [
        {
          type: "constructor",
          inputs: [
            {
              name: "_challengeManager",
              type: "address",
              internalType: "contract RegenChallengeManager",
            },
          ],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "challengeManager",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "contract RegenChallengeManager",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "freezeOperator",
          inputs: [
            {
              name: "operatorAddr",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
      ],
      inheritedFunctions: {},
    },
  },
} as const;

export default deployedContracts satisfies GenericContractsDeclaration;
