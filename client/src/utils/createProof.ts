const snarkjs = require("snarkjs");
export const generateProof = async (
  nullifier: bigint,
  nullifierHash: bigint,
  address: string,
  secret: bigint,
  commitmentHash: bigint
) => {
  const input = {
    nullifier: nullifier,
    nullifierHash: nullifierHash,
    recipient: address,
    secret: secret,
    commitment: commitmentHash,
  };

  const { proof, publicSignals } = await snarkjs.groth16.fullProve(
    input,
    "Withdraw.wasm",
    "Withdraw_0001.zkey"
  );
  return proof;
};
