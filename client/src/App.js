import "./App.css";
import { connect, disconnect } from "@argent/get-starknet";
import { useState } from "react";
import { Contract } from "starknet";
function App() {
  const [account, setAccount] = useState(null);
  async function connectWallet() {
    const connection = await connect();
    if (connection && connection.isConnected) {
      setAccount(connection.account);
    }
  }
  return (
    <div>
      <button onClick={connectWallet}>Connect</button>
    </div>
  );
}

export default App;
