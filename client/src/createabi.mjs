import { Contract, RpcProvider, json } from "starknet";
import { writeFileSync } from "fs";
const provider = new RpcProvider({
  nodeUrl: "https://starknet-sepolia.public.blastapi.io/rpc/v0_7",
});
const addrContract =
  "0x049D36570D4e46f48e99674bd3fcc84644DdD6b96F7C741B1562B82f9e004dC7";
const compressedContract = await provider.getClassAt(addrContract);
writeFileSync(
  "./ETHAbi.json",
  json.stringify(compressedContract.abi, undefined, 2)
);
