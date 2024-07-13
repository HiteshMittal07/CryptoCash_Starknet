import React from "react";
import { approve, getContract, getProvider } from "../web3/web3";
import { rbigint } from "../utils/random";
import { commitmentHash } from "../utils/createHash";

export default function CreateNote(props: any) {
  async function createNote() {
    const account = props.account;
    const contract = getContract(account);
    const provider = getProvider();
    const inputElement = document.querySelector("#amount") as HTMLInputElement;
    const inputElement2 = document.querySelector(
      "#address"
    ) as HTMLInputElement;
    const address = inputElement2.value.toString();
    const amount = inputElement.value.toString();
    await approve(amount, account, address);
    await new Promise((resolve) => setTimeout(resolve, 3000));
    const secret = rbigint();
    console.log(secret);
    const nullifier = rbigint();
    console.log(nullifier);
    const commitment_hash = commitmentHash(nullifier, secret);
    console.log(commitment_hash);
    try {
      const tx = await contract.createNote(commitment_hash, amount, address);
      // const transactionHash = tx.transaction_hash;
      // console.log(transactionHash);
      // const txReceipt = await provider.waitForTransaction(transactionHash);
      // const listEvents = txReceipt.events;
      // console.log(listEvents[2].keys[1]);
      // console.log(parseInt(listEvents[2].data[0], 16));
    } catch (error) {
      alert(error);
    }
  }
  return (
    <div>
      <input type="text" id="amount" placeholder="enter the amount" />
      <input type="text" id="address" placeholder="enter token address" />
      <button onClick={createNote}>Create</button>
    </div>
  );
}
