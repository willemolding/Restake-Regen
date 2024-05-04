import { useState } from "react";
import ToggleButton from "@mui/material/ToggleButton";
import ToggleButtonGroup from "@mui/material/ToggleButtonGroup";
import { IDKitWidget, ISuccessResult } from "@worldcoin/idkit";
import { decodeAbiParameters, parseEther } from "viem";
import { useAccount } from "wagmi";
import { AddressInput } from "~~/components/scaffold-eth";
import { useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

export const RegisterCommitmentForm = () => {
  const { address } = useAccount();
  const [operator, setOperator] = useState("");
  const [amount, setAmount] = useState("0.0001");
  const [worldcoinProof, setWorldcoinproof] = useState<ISuccessResult | null>(null);

  const { writeContractAsync: writeRegenPledgeRegistry } = useScaffoldWriteContract("RegenPledgeRegistry");

  const submitTransaction = async () => {
    console.log(`Registering commitment for operator ${operator} with amount ${amount}`);

    const proof = decodeAbiParameters([{ name: "x", type: "uint256[8]" }], worldcoinProof?.proof)[0];
    console.log(proof);
    await writeRegenPledgeRegistry({
      functionName: "makePledge",
      args: [operator, parseEther(amount), worldcoinProof?.merkle_root, worldcoinProof?.nullifier_hash, proof],
    });
  };

  const onSuccess = (result: ISuccessResult) => {
    setWorldcoinproof(result);
  };

  return (
    <div>
      <span className="block text-2xl mb-2">Make a pledge to offset network emissions</span>
      {!worldcoinProof ? (
        <IDKitWidget
          app_id="app_staging_64d94c0a4c6d65f0a63e059939e58887"
          action="register-for-restakeregen" // this is your action name from the Developer Portal
          signal={address} // any arbitrary value the user is committing to, e.g. a vote
          onSuccess={onSuccess}
        >
          {({ open }) => <button onClick={open}>Verify with World ID</button>}
        </IDKitWidget>
      ) : (
        <div>
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
      )}
    </div>
  );
};
