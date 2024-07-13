import { Contract, RpcProvider } from "starknet";
import ETH_token_ABI from "../ABI/ETHAbi.json";
import STRK_token_ABI from "../ABI/STRKAbi.json";
import contractABI from "../ABI/myAbi.json";
export const STRK_token_address =
  "0x04718f5a0Fc34cC1AF16A1cdee98fFB20C31f5cD61D6Ab07201858f4287c938D";
export const ETH_token_address =
  "0x049D36570D4e46f48e99674bd3fcc84644DdD6b96F7C741B1562B82f9e004dC7";
export const Contract_Address =
  "0x03073f6b8d87d244898203cf5e7e04ac55eda6b029d69b99c36f0431b6cd100e";

export function toHex(number: number) {
  const bigIntNumber = BigInt(number);
  const hexString = bigIntNumber.toString(16);
  return "0x" + hexString;
}

export function getContract(account: any) {
  const contract = new Contract(contractABI, Contract_Address, account);
  return contract;
}
export function getProvider() {
  const provider = new RpcProvider({
    nodeUrl: "https://starknet-sepolia.public.blastapi.io/rpc/v0_7",
  });
  return provider;
}
export function get_token_contract(token_address: any, account: any) {
  if (token_address == ETH_token_address) {
    return new Contract(ETH_token_ABI, ETH_token_address, account);
  } else {
    return new Contract(STRK_token_ABI, STRK_token_address, account);
  }
}
export async function approve(
  amount: string,
  account: any,
  token_address: any
) {
  const contract_Token = get_token_contract(token_address, account);
  try {
    const tx1 = await contract_Token.approve(Contract_Address, amount);
    console.log(tx1);
  } catch (error) {
    alert(error);
    return;
  }
}
