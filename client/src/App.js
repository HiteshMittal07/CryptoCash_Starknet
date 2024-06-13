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
    "0x003300c4a4bba7ff2362fc5e44e5cb8e477577f51bde4b96a3628fb20f5f885c";
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

  async function get_status() {
    const provider = new RpcProvider({
      nodeUrl: "https://starknet-sepolia.public.blastapi.io/rpc/v0_7",
    });
    console.log(provider);
    const contract = new Contract(contractABI, Contract_Address, provider);
    const status = await contract.get_note_status({ low: 10000, high: 200 });
    console.log(status);
  }
  async function getCaller() {
    const provider = new RpcProvider({
      nodeUrl: "https://starknet-sepolia.public.blastapi.io/rpc/v0_7",
    });
    console.log(provider);
    const contract = new Contract(contractABI, Contract_Address, account);
    const status = await contract.get_caller();
    console.log(status);
  }
  return (
    <div>
      <button onClick={connectWallet}>Connect</button>
      <button onClick={get_owner}>get_owner</button>
      <button onClick={createNote}>create</button>
      <button onClick={get_status}>status</button>
      <button onClick={getCaller}>caller</button>
    </div>
  );
}

export default App;
