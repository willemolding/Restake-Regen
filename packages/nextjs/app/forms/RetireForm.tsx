import { useState } from "react";
import { parseEther } from "viem";
import { useAccount } from "wagmi";
import { AddressInput, IntegerInput } from "~~/components/scaffold-eth";
import { useScaffoldWriteContract } from "~~/hooks/scaffold-eth";

export const RetireForm = () => {
  const { address } = useAccount();
  const [projectToken, setProjectToken] = useState("0xd0844B61Dcd657EE937D3CD8cF0a4b83a87218cD");
  const [amount, setAmount] = useState(BigInt(0));
  const maxFee = parseEther("100");

  const { writeContractAsync: writeFundingPool } = useScaffoldWriteContract("FundingPool");

  const submitTransaction = async () => {
    await writeFundingPool({
      functionName: "retire",
      args: [[projectToken], [amount], maxFee],
    });
  };

  return (
    <div>
      <span className="block text-2xl mb-2">Retire carbon credits from the pool to offset C02</span>
      <label className="block text-sm font-medium">Project Token (defaults to oldest in pool)</label>
      <AddressInput value={projectToken} onChange={value => setProjectToken(value)} />
      <label className="block text-sm font-medium">Amount</label>
      <IntegerInput value={amount} onChange={value => setAmount(value as bigint)} />
      <button className="btn btn-sm btn-primary" onClick={submitTransaction}>
        Retire
      </button>
    </div>
  );
};
