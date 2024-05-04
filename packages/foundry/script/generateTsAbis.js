const fs = require("fs");
const path = require("path");
//@ts-expect-error  This script runs after `forge deploy` therefore its deterministic that it will present
// const deployments = require("../deployments.json");
const prettier = require("prettier");

const generatedContractComment = `
/**
 * This file is autogenerated by Scaffold-ETH.
 * You should not edit it manually or your changes might be overwritten.
 */
`;

function getDirectories(path) {
  return fs.readdirSync(path).filter(function (file) {
    return fs.statSync(path + "/" + file).isDirectory();
  });
}
function getFiles(path) {
  return fs.readdirSync(path).filter(function (file) {
    return fs.statSync(path + "/" + file).isFile();
  });
}
function getArtifactOfContract(contractName) {
  const current_path_to_artifacts = path.join(
    __dirname,
    "..",
    `out/${contractName}.sol`
  );
  const artifactJson = JSON.parse(
    fs.readFileSync(`${current_path_to_artifacts}/${contractName}.json`)
  );

  return artifactJson;
}

function getInheritedFromContracts(artifact) {
  let inheritedFromContracts = [];
  if (artifact?.ast) {
    for (const astNode of artifact.ast.nodes) {
      if (astNode.nodeType == "ContractDefinition") {
        if (astNode.baseContracts.length > 0) {
          inheritedFromContracts = astNode.baseContracts.map(
            ({ baseName }) => baseName.name
          );
        }
      }
    }
  }
  return inheritedFromContracts;
}

function getInheritedFunctions(mainArtifact) {
  const inheritedFromContracts = getInheritedFromContracts(mainArtifact);
  const inheritedFunctions = {};
  for (const inheritanceContractName of inheritedFromContracts) {
    const {
      abi,
      ast: { absolutePath },
    } = getArtifactOfContract(inheritanceContractName);
    for (const abiEntry of abi) {
      if (abiEntry.type == "function") {
        inheritedFunctions[abiEntry.name] = absolutePath;
      }
    }
  }
  return inheritedFunctions;
}

function main() {
  const current_path_to_broadcast = path.join(
    __dirname,
    "..",
    "broadcast/DeployL1.s.sol"
  );
  const current_path_to_deployments = path.join(__dirname, "..", "deployments");

  const chains = getDirectories(current_path_to_broadcast);
  const Deploymentchains = getFiles(current_path_to_deployments);

  const deployments = {};

  Deploymentchains.forEach((chain) => {
    if (!chain.endsWith(".json")) return;
    chain = chain.slice(0, -5);
    var deploymentObject = JSON.parse(
      fs.readFileSync(`${current_path_to_deployments}/${chain}.json`)
    );
    deployments[chain] = deploymentObject;
  });

  const allGeneratedContracts = {};

  chains.forEach((chain) => {
    allGeneratedContracts[chain] = {};
    const broadCastObject = JSON.parse(
      fs.readFileSync(`${current_path_to_broadcast}/${chain}/run-latest.json`)
    );
    const transactionsCreate = broadCastObject.transactions.filter(
      (transaction) => transaction.transactionType == "CREATE"
    );
    transactionsCreate.forEach((transaction) => {
      const artifact = getArtifactOfContract(transaction.contractName);
      allGeneratedContracts[chain][
        deployments[chain][transaction.contractAddress] ||
          transaction.contractName
      ] = {
        address: transaction.contractAddress,
        abi: artifact.abi,
        inheritedFunctions: getInheritedFunctions(artifact),
      };
    });
  });

  const TARGET_DIR = "../nextjs/contracts/";

  const fileContent = Object.entries(allGeneratedContracts).reduce(
    (content, [chainId, chainConfig]) => {
      return `${content}${parseInt(chainId).toFixed(0)}:${JSON.stringify(
        chainConfig,
        null,
        2
      )},`;
    },
    ""
  );

  if (!fs.existsSync(TARGET_DIR)) {
    fs.mkdirSync(TARGET_DIR);
  }
  fs.writeFileSync(
    `${TARGET_DIR}deployedContracts.ts`,
    prettier.format(
      `${generatedContractComment} import { GenericContractsDeclaration } from "~~/utils/scaffold-eth/contract"; \n\n
 const deployedContracts = {${fileContent}} as const; \n\n export default deployedContracts satisfies GenericContractsDeclaration`,
      {
        parser: "typescript",
      }
    )
  );
}

try {
  main();
} catch (error) {
  console.error(error);
  process.exitCode = 1;
}
