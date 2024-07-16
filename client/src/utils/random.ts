import { utils } from "ffjavascript";
import crypto from "../modules/crypto-browserify";

export function random(): bigint {
  return utils.leBuff2int(crypto.randomBytes(31));
}
