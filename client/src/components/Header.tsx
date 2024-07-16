import React, { useContext, useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { toast } from "react-toastify";
import { CryptoContext } from "../context/cryptoContext";
import { Button, Navbar } from "flowbite-react";
import { useDynamicContext } from "@dynamic-labs/sdk-react-core";
const Header = () => {
  const [display, setDisplay] = useState("");
  const { setShowAuthFlow, primaryWallet } = useDynamicContext();
  const { account, setAccount } = useContext(CryptoContext);
  const truncateWalletAddress = async (address: any, length = 4) => {
    if (!address) return "";
    const start = address.substring(0, length);
    const end = address.substring(address.length - length);
    setDisplay(`${start}...${end}`);
  };
  function connectWalletL2() {
    if (!primaryWallet) {
      setShowAuthFlow(true);
    } else {
      toast.success("connected");
    }
  }

  useEffect(() => {
    const connect = async () => {
      if (primaryWallet) {
        const signer = await primaryWallet.connector.getSigner();
        setAccount(signer);
        truncateWalletAddress(primaryWallet.address);
      }
    };
    connect();
  }, [primaryWallet]);

  return (
    <Navbar fluid rounded className="bg-black shadow-lg text-white">
      <Navbar.Brand href="/">
        <span className="self-center whitespace-nowrap text-xl font-semibold text-white ml-20">
          Crypto Cash
        </span>
      </Navbar.Brand>
      <div className="flex md:order-2 mr-20">
        {!account ? (
          <Button color="dark" onClick={connectWalletL2}>
            Connect Wallet
          </Button>
        ) : (
          <Button color="dark" onClick={connectWalletL2}>
            {display}
          </Button>
        )}
        <Navbar.Toggle />
      </div>
      <Navbar.Collapse>
        <Link to="/create">Create</Link>
        <Link to="/withdraw">Withdraw</Link>
        <Link to="/info">Info</Link>
      </Navbar.Collapse>
    </Navbar>
  );
};

export default Header;
