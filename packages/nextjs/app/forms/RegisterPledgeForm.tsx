import { useState } from "react";
import { AddressInput, IntegerInput } from "~~/components/scaffold-eth";
import { useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

export const RegisterCommitmentForm = () => {
  const [operator, setOperator] = useState("");
  const [amount, setAmount] = useState(BigInt(0));

  const { writeContractAsync: writeRegenPledgeRegistry } = useScaffoldWriteContract("RegenPledgeRegistry");

  const submitTransaction = async () => {
    console.log(`Registering commitment for operator ${operator} with amount ${amount}`);
    await writeRegenPledgeRegistry({
      functionName: "makePledge",
      args: [operator, amount],
    });
  };

  return (
    <div>
      <span className="block text-2xl mb-2">
        Make a pledge to offset carbon emissions that is backed by your stake in Eigenlayer
      </span>
      <label className="block text-sm font-medium">Operator</label>
      <AddressInput value={operator} onChange={value => setOperator(value)} />
      <label className="block text-sm font-medium">Pledge Amount in 1e-18 shares of total network emissions</label>
      <IntegerInput value={amount} onChange={value => setAmount(value as bigint)} />
      <button className="btn btn-sm btn-primary" onClick={submitTransaction}>
        Make Commitment
      </button>
    </div>
  );
};
