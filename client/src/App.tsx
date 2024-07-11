import React, { useState } from "react";
import "./App.css";
import { connect } from "@argent/get-starknet";
import CreateNote from "./components/createNote";
import { Button } from "flowbite-react";
function App() {
  const [account, setAccount] = useState();

  async function connectWallet() {
    const connection = await connect({ dappName: "CryptoCash" });
    if (connection && connection.isConnected) {
      setAccount(connection.account);
    }
  }

  return (
    <div className="App">
      <Button onClick={connectWallet}>Connect Wallet</Button>
      <CreateNote />
    </div>
  );
}

export default App;
