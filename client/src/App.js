import "./App.css";
import { connect, disconnect } from "@argent/get-starknet";
import { useState } from "react";
import { Contract, RpcProvider, json } from "starknet";
import contractABI from "./abis/myAbi.json";
import random from "./utils/random";
import { commitmentHash } from "./utils/createHash";
// import "dotenv/config";
function App() {
  const [account, setAccount] = useState(null);
  const Contract_Address =
    "0x060942c0b6e4bec865e845eb5f952bceb6ce07ab870c4b0728edc7e0dbaa728b";
  async function connectWallet() {
    const connection = await connect();
    if (connection && connection.isConnected) {
      setAccount(connection.account);
    }
  }
  async function createNote() {
    const contract = new Contract(contractABI, Contract_Address, account);
    const secret = random();
    console.log(secret);
    const nullifier = random();
    const commitment_hash = commitmentHash(
      parseInt(nullifier),
      parseInt(secret)
    );
    console.log(commitment_hash);
    const hex_commitment_hash = "0x" + commitment_hash.toString(16);
    const tx = await contract.createNote(
      { low: 10000, high: 200 },
      { low: 1000, high: 0 }
    );
  }
  async function get_owner() {
    const provider = new RpcProvider({
      nodeUrl: "https://starknet-sepolia.public.blastapi.io/rpc/v0_7",
    });
    console.log(provider);
    const contract = new Contract(contractABI, Contract_Address, provider);
    console.log(contract);
    const owner = await contract.get_owner();
    console.log(owner.toString(16));
  }
  return (
    <div>
      <button onClick={connectWallet}>Connect</button>
      <button onClick={get_owner}>get_owner</button>
      <button onClick={createNote}>create</button>
    </div>
  );
}

export default App;
