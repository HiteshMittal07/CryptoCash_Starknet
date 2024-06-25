import { utils } from "ffjavascript";
import crypto from "../modules/crypto-browserify";

export function rbigint(): bigint {
  return utils.leBuff2int(crypto.randomBytes(31));
}
