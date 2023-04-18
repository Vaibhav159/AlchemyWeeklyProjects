const secp = require("ethereum-cryptography/secp256k1");
const {toHex, utf8ToBytes} = require("ethereum-cryptography/utils");
const {keccak256} = require("ethereum-cryptography/keccak");

function hashMessage(message) {
    return keccak256(utf8ToBytes(message));
}


exports.signMessage =  async function signMessage(msg, privateKey){

    const hashed_message = hashMessage(msg);

    const [signature, recoveryBit] = await secp.sign(hashed_message, privateKey, { recovered: true });

    console.log(signature, recoveryBit);

    return [signature, recoveryBit];
}

function getAddress(publicKey) {
    const sliced_key = publicKey.slice(1);
    const hashed = keccak256(sliced_key);
    return hashed.slice(-20);
}

exports.recoveryKeyAddress = function recoveryKeyAddress(msg, signature, recoveryBit){

    const hashed_message = hashMessage(msg);

    let recoveredPublicKey = secp.recoverPublicKey(hashed_message, signature, recoveryBit);

    return toHex(getAddress(recoveredPublicKey));
}
