"use client";

import Link from "next/link";
import { RegisterCommitmentForm } from "./forms/RegisterCommitmentForm";
import { ContributeForm } from "./forms/ContributeForm";

import type { NextPage } from "next";
import { useAccount } from "wagmi";
import { Address } from "~~/components/scaffold-eth";

const Home: NextPage = () => {
  const { address: connectedAddress } = useAccount();

  return (
    <>
      <div className="flex items-center flex-col flex-grow pt-10">
        <div className="px-5">
          <h1 className="text-center">
            <span className="block text-4xl font-bold">Restake // Regen</span>
          </h1>
          <div className="flex justify-center items-center space-x-2">
            <p className="my-2 font-medium">Connected Address:</p>
            <Address address={connectedAddress} />
          </div>
          <ContributeForm />
        </div>
      </div>
    </>
  );
};

export default Home;
