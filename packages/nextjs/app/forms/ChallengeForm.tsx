import { useState } from "react";
import { parseEther } from "viem";
import { AddressInput, IntegerInput } from "~~/components/scaffold-eth";
import { useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

export const ChallengeForm = () => {
  const [operator, setOperator] = useState("");
  const [epoch, setEpoch] = useState(BigInt(0));

  const { writeContractAsync: writeFundingPool } = useScaffoldWriteContract("FundingPool");

  const submitTransaction = async () => {
    console.log(`Challenging operator ${operator} in epoch ${epoch}`);

    await writeFundingPool({
      functionName: "challenge",
      args: [operator, epoch],
      value: parseEther("0.1"),
    });
  };

  return (
    <div>
      <span className="block text-2xl mb-2">
        Challenge an operator who did not fulfil their pledge in a previous epoch
      </span>
      <label className="block text-sm font-medium">For Operator</label>
      <AddressInput value={operator} onChange={value => setOperator(value)} />
      <label className="block text-sm font-medium">in Epoch</label>
      <IntegerInput value={epoch} onChange={value => setEpoch(value as bigint)} />
      <button className="btn btn-sm btn-primary" onClick={submitTransaction}>
        Challenge
      </button>
    </div>
  );
};
