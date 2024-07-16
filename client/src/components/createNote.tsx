import React, { useContext } from "react";
import {
  approve,
  get_token_name,
  getContract,
  getProvider,
} from "../web3/web3";
import { random } from "../utils/random";
import { commitmentHash, nullifierHash } from "../utils/createHash";
import { Button } from "flowbite-react";
import { downloadQRCodePDF } from "../utils/downloadNote";
import { CreateNoteQR } from "../utils/createNoteQR";
import { CryptoContext } from "../context/cryptoContext";

export default function CreateNote() {
  const { account } = useContext(CryptoContext);
  async function createNote() {
    const contract = getContract(account);
    const provider = getProvider();
    const inputElement = document.querySelector("#amount") as HTMLInputElement;
    const inputElement2 = document.querySelector(
      "#address"
    ) as HTMLInputElement;
    const address = inputElement2.value.toString();
    const amount = inputElement.value.toString();
    await approve(amount, account, address);
    await new Promise((resolve) => setTimeout(resolve, 5000));
    const secret = random();
    console.log(secret);
    const nullifier = random();
    console.log(nullifier);
    const commitment_hash = commitmentHash(nullifier, secret);
    console.log(commitment_hash);
    try {
      const tx = await contract.createNote(commitment_hash, amount, address);
      const transactionHash = tx.transaction_hash;
      console.log(transactionHash);
      const txReceipt = await provider.waitForTransaction(transactionHash);
      console.log("🚀 ~ createNote ~ txReceipt:", txReceipt);
      const note_string = `${secret},${nullifier},${nullifierHash},${commitment_hash},${amount},${address}`;
      const qrDataURL = await CreateNoteQR(note_string);
      const token_name = get_token_name(address);
      downloadQRCodePDF(qrDataURL, amount, token_name);
    } catch (error) {
      alert(error);
    }
  }
  return (
    <div className="flex flex-col m-20">
      <input type="text" id="amount" placeholder="enter the amount" />
      <input type="text" id="address" placeholder="enter token address" />
      <Button onClick={createNote}>Create</Button>
    </div>
  );
}
