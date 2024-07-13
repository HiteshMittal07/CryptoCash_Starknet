import { createContext } from "react";
interface CryptoContextType {
  account: any | null;
  setAccount: React.Dispatch<React.SetStateAction<any | null>>;
}

const defaultContext: CryptoContextType = {
  account: null,
  setAccount: () => {},
};

export const CryptoContext = createContext<CryptoContextType>(defaultContext);
