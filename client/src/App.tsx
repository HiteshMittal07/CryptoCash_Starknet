import React, { useMemo, useState } from "react";
import "./App.css";
import { connect } from "@argent/get-starknet";
import CreateNote from "./components/createNote";
import { Button } from "flowbite-react";
import { CryptoContext } from "./context/cryptoContext";
import Header from "./components/Header";
function App() {
  const [account, setAccount] = useState<any | null>(null);

  async function connectWallet() {
    const connection = await connect({ dappName: "CryptoCash" });
    if (connection && connection.isConnected) {
      setAccount(connection.account);
    }
  }
  const contextValue = useMemo(
    () => ({ account, setAccount }),
    [account, setAccount]
  );
  return (
    <CryptoContext.Provider value={contextValue}>
      <div className="App">
        <Header />
        <CreateNote account={account} />
      </div>
    </CryptoContext.Provider>
  );
}

export default App;
