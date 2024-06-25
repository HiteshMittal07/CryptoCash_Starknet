import { poseidon } from "circomlibjs";
export const nullifierHash = (nullifier: string | bigint) => {
  return poseidon([BigInt(nullifier)]);
};

export const commitmentHash = (
  nullifier: string | bigint,
  secret: string | bigint
) => {
  return poseidon([BigInt(nullifier), BigInt(secret)]);
};
