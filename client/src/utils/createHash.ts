import * as starknet from "starknet";
export const nullifierHash = (nullifier: string) => {
  return starknet.hash.computePoseidonHashOnElements([BigInt(nullifier)]);
};

export const commitmentHash = (
  nullifier: string | bigint,
  secret: string | bigint
) => {
  return starknet.hash.computePoseidonHash(BigInt(nullifier), BigInt(secret));
};
