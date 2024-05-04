"use client";

import { useState } from "react";
import Link from "next/link";
import { ChallengeForm } from "./forms/ChallengeForm";
import { ContributeForm } from "./forms/ContributeForm";
import { RegisterCommitmentForm } from "./forms/RegisterPledgeForm";
import { RetireForm } from "./forms/RetireForm";
import Box from "@mui/material/Box";
import Tab from "@mui/material/Tab";
import Tabs from "@mui/material/Tabs";
import type { NextPage } from "next";
import { formatEther } from "viem";
import { useAccount } from "wagmi";
import { Address } from "~~/components/scaffold-eth";
import { useScaffoldReadContract } from "~~/hooks/scaffold-eth";
import { getAllContracts } from "~~/utils/scaffold-eth/contractsData";

const Home: NextPage = () => {
  const [tab, setTab] = useState(0);
  const { address: connectedAddress } = useAccount();
  const fundingPoolAddress = getAllContracts()?.FundingPool.address;
  const { data: charInPool } = useScaffoldReadContract({
    contractName: "CHAR",
    functionName: "balanceOf",
    args: [fundingPoolAddress],
  });
  return (
    <>
      <div className="flex items-center flex-col flex-grow pt-10">
        <div className="px-5">
          <h1 className="text-center">
            <span className="block text-4xl font-bold">Restake // Regen</span>
            <span className="block text-2xl font-bold">
              Pool currently holds {formatEther(charInPool || BigInt(0))} CHAR
            </span>
          </h1>
          <div className="flex justify-center items-center space-x-2">
            <p className="my-2 font-medium">Connected Address:</p>
            <Address address={connectedAddress} />
          </div>

          <Box sx={{ borderBottom: 1, borderColor: "divider" }}>
            <Tabs value={tab} onChange={(event, newValue) => setTab(newValue)} aria-label="basic tabs example" centered>
              <Tab label="Pledge" />
              <Tab label="Contribute" />
              <Tab label="Retire" />
              <Tab label="Challenge" />
            </Tabs>
          </Box>

          <TabPanel value={tab} index={0}>
            <RegisterCommitmentForm />
          </TabPanel>
          <TabPanel value={tab} index={1}>
            <ContributeForm />
          </TabPanel>
          <TabPanel value={tab} index={2}>
            <RetireForm />
          </TabPanel>
          <TabPanel value={tab} index={3}>
            <ChallengeForm />
          </TabPanel>
        </div>
      </div>
    </>
  );
};

function TabPanel(props: any) {
  const { children, value, index, ...other } = props;

  return (
    <div role="tabpanel" hidden={value !== index} id={`tabpanel-${index}`} aria-labelledby={`tab-${index}`} {...other}>
      {value === index && <Box sx={{ p: 3 }}>{children}</Box>}
    </div>
  );
}

export default Home;
