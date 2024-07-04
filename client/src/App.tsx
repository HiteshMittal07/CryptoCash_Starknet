import React, { useState } from "react";
import "./App.css";
import { connect } from "@argent/get-starknet";
import CreateNote from "./components/createNote";
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
      <button onClick={connectWallet}>Connect Wallet</button>
      <CreateNote />
    </div>
  );
}

export default App;
