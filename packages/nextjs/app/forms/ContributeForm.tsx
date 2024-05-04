import { useState } from "react";
import { useAccount } from "wagmi";
import { AddressInput, IntegerInput } from "~~/components/scaffold-eth";
import { useScaffoldWriteContract } from "~~/hooks/scaffold-eth";
import { getAllContracts } from "~~/utils/scaffold-eth/contractsData";

export const ContributeForm = () => {
  const { address } = useAccount();
  const [operator, setOperator] = useState("");
  const [amount, setAmount] = useState(BigInt(0));

  const fundingPoolAddress = getAllContracts()?.FundingPool.address;

  const { writeContractAsync: writeFundingPool } = useScaffoldWriteContract("FundingPool");
  const { writeContractAsync: writeChar } = useScaffoldWriteContract("CHAR");

  const submitTransaction = async () => {
    console.log(`Contribution for operator ${operator} with amount ${amount}`);
    // approve the funding pool contract to spend the CHAR
    await writeChar({
      functionName: "approve",
      args: [fundingPoolAddress, amount],
    });

    await writeFundingPool({
      functionName: "contribute",
      args: [address, amount, operator],
    });
  };

  return (
    <div>
      <span className="block text-2xl mb-2">Fulfil your pledge and send CHAR to the pool</span>
      <label className="block text-sm font-medium">Amount</label>
      <IntegerInput value={amount} onChange={value => setAmount(value as bigint)} />
      <label className="block text-sm font-medium">For Operator</label>
      <AddressInput value={operator} onChange={value => setOperator(value)} />
      <button className="btn btn-sm btn-primary" onClick={submitTransaction}>
        Fulfil
      </button>
    </div>
  );
};
