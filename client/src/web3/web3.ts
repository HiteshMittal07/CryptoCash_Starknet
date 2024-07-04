import { Contract, RpcProvider } from "starknet";
import contract_token_ABI from "../ABI/STRKAbi.json";
import contractABI from "../ABI/myAbi.json";
export const STRK_token_address =
  "0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d";
export const ETH_token_address =
  "0x049D36570D4e46f48e99674bd3fcc84644DdD6b96F7C741B1562B82f9e004dC7";
export const Contract_Address =
  "0x062816a8d6e835b79f1e1962bf30976dc2957c2e126b22beb970419180d502f2";

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
export function get_token_contract() {}
export async function approve(amount: string, account: any) {
  const contract_Token = new Contract(
    contract_token_ABI,
    STRK_token_address,
    account
  );
  try {
    const tx1 = await contract_Token.approve(Contract_Address, amount);
    console.log(tx1);
  } catch (error) {
    alert(error);
    return;
  }
}
