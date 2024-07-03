import React, { useState } from "react";
import "./App.css";
import { rbigint } from "./utils/random";
import { connect } from "@argent/get-starknet";
import { Contract, RpcProvider } from "starknet";
import contract_token_ABI from "./ABI/ETHAbi.json";
import { commitmentHash } from "./utils/createHash";
function App() {
  const [account, setAccount] = useState();
  const STRK_token_address = "";
  const Contract_Address = "";
  async function connectWallet() {
    const connection = await connect({ dappName: "CryptoCash" });
    if (connection && connection.isConnected) {
      setAccount(connection.account);
    }
  }
  async function approve(amount: string) {
    const contract_Token = new Contract(
      contract_token_ABI,
      STRK_token_address,
      account
    );
    try {
      const tx1 = await contract_Token.approve(Contract_Address, amount);
      console.log(tx1);
    } catch (error) {
      alert(error);
      return;
    }
  }
  async function createNote() {
    const contract = new Contract(contractABI, Contract_Address, account);
    const provider = new RpcProvider({
      nodeUrl: "https://starknet-sepolia.public.blastapi.io/rpc/v0_7",
    });
    const inputElement = document.querySelector("#amount") as HTMLInputElement;
    const amount = inputElement.value.toString();
    await approve(amount);
    await new Promise((resolve) => setTimeout(resolve, 3000));
    const secret = rbigint();
    console.log(secret);
    const nullifier = rbigint();
    const commitment_hash = commitmentHash(
      parseInt(nullifier),
      parseInt(secret)
    );
    console.log(commitment_hash);
    const hex_commitment_hash = toHex(commitment_hash);
    console.log(hex_commitment_hash);
    try {
      const tx = await contract.createNote(
        hex_commitment_hash,
        STRK_token_address,
        amount
      );
      const transactionHash = tx.transaction_hash;
      console.log(transactionHash);
      const txReceipt = await provider.waitForTransaction(transactionHash);
      const listEvents = txReceipt.events;
      console.log(listEvents[2].keys[1]);
      console.log(parseInt(listEvents[2].data[0], 16));
    } catch (error) {
      alert(error);
    }
  }
  function toHex(number: number) {
    const bigIntNumber = BigInt(number);
    const hexString = bigIntNumber.toString(16);
    return "0x" + hexString;
  }
  return <div className="App"></div>;
}

export default App;
