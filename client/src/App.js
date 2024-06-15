import "./App.css";
import { connect, disconnect } from "@argent/get-starknet";
import { useState } from "react";
import { Contract, RpcProvider, json } from "starknet";
import contractABI from "./abis/myAbi.json";
import contract_token_ABI from "./abis/STRKAbi.json";
import random from "./utils/random";
import { commitmentHash } from "./utils/createHash";
import bigInt from "big-integer";
// import "dotenv/config";
function App() {
  const [account, setAccount] = useState(null);
  const Contract_Address =
    "0x02819aa999b4d7d69591bce951c6d5b6adb8c4c04a0292158d1628923a48e081";
  const STRK_token_address =
    "0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d";
  const ETH_token_address =
    "0x049D36570D4e46f48e99674bd3fcc84644DdD6b96F7C741B1562B82f9e004dC7";
  async function connectWallet() {
    const connection = await connect();
    if (connection && connection.isConnected) {
      setAccount(connection.account);
    }
  }
  async function createNote() {
    const contract = new Contract(contractABI, Contract_Address, account);
    const amount = document.querySelector("#amount").value.toString();
    const contract_Token = new Contract(
      contract_token_ABI,
      STRK_token_address,
      account
    );
    try {
      const tx1 = await contract_Token.approve(Contract_Address, amount);
    } catch (error) {
      alert(error);
      return;
    }
    const secret = random();
    console.log(secret);
    const nullifier = random();
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
    } catch (error) {
      alert(error);
    }
  }

  function toHex(number) {
    // Ensure the input is a BigInt
    const bigIntNumber = bigInt(number);

    // Convert the BigInt to a hexadecimal string
    const hexString = bigIntNumber.toString(16);

    // Return the hexadecimal string with '0x' prefix
    return "0x" + hexString;
  }

  async function get_status() {
    const commitment_hash = document.querySelector("#status").value;
    const provider = new RpcProvider({
      nodeUrl: "https://starknet-sepolia.public.blastapi.io/rpc/v0_7",
    });
    console.log(provider);
    const contract = new Contract(contractABI, Contract_Address, provider);
    const status = await contract.get_note_status(commitment_hash);
    console.log(status);
  }
  return (
    <div>
      <button onClick={connectWallet}>Connect</button>
      <input type="text" id="amount" placeholder="enter the amount of note" />
      <button onClick={createNote}>create</button>
      <input
        type="text"
        id="status"
        placeholder="enter the commitment here to check the status"
      />
      <button onClick={get_status}>status</button>
    </div>
  );
}

export default App;
