import { useState } from "react";
import ToggleButton from "@mui/material/ToggleButton";
import ToggleButtonGroup from "@mui/material/ToggleButtonGroup";
import { parseEther } from "viem";
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
      args: [operator, parseEther(amount)],
    });
  };

  return (
    <div>
      <span className="block text-2xl mb-2">
        Make a pledge to offset network emissions
      </span>
      <label className="block text-sm font-medium">Operator</label>
      <AddressInput value={operator} onChange={value => setOperator(value)} />
      <label className="block text-sm font-medium">Pledge Amount as a fraction of total network emissions</label>
      <ToggleButtonGroup
        color="primary"
        value={amount}
        exclusive
        onChange={(event, newValue) => setAmount(newValue)}
        aria-label="Platform"
      >
        <ToggleButton value="0.00001">0.001%</ToggleButton>
        <ToggleButton value="0.0001">0.01%</ToggleButton>
        <ToggleButton value="0.001">1%</ToggleButton>
      </ToggleButtonGroup>
      <br />
      <button className="btn btn-sm btn-primary" onClick={submitTransaction}>
        Make Commitment
      </button>
    </div>
  );
};
