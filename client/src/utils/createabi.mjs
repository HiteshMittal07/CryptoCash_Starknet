import { Contract, RpcProvider, json } from "starknet";
import { writeFileSync } from "fs";

const provider = new RpcProvider({
  nodeUrl: "https://starknet-sepolia.public.blastapi.io/rpc/v0_7",
});
const addrContract =
  "0x03073f6b8d87d244898203cf5e7e04ac55eda6b029d69b99c36f0431b6cd100e";
const compressedContract = await provider.getClassAt(addrContract);
writeFileSync(
  "./myAbi.json",
  json.stringify(compressedContract.abi, undefined, 2)
);
