import React from "react";
import "./App.css";
import { rbigint } from "./utils/random";
function App() {
  const Hash = () => {
    const secret = rbigint();
    const nullifier = rbigint();
    console.log(secret);
    console.log(nullifier);
  };
  return (
    <div className="App">
      <button onClick={Hash}>call</button>
    </div>
  );
}

export default App;
