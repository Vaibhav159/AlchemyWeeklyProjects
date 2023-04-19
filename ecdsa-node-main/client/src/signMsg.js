import * as secp from 'ethereum-cryptography/secp256k1';
import * as keccak from 'ethereum-cryptography/keccak';
import * as utils from 'ethereum-cryptography/utils';

function hashMessage(message) {
    return keccak.keccak256(utils.utf8ToBytes(message));
}


export async function signMessage(msg, privateKey){

    const hashed_message = hashMessage(msg);

    const [signature, recoveryBit] = await secp.sign(hashed_message, privateKey, { recovered: true });

    console.log(signature, recoveryBit);

    return [signature, recoveryBit];
}

function getAddress(publicKey) {
    const sliced_key = publicKey.slice(1);
    const hashed = keccak.keccak256(sliced_key);
    return hashed.slice(-20);
}

export async function recoveryKeyAddress(msg, signature, recoveryBit){

    const hashed_message = hashMessage(msg);

    let recoveredPublicKey = await secp.recoverPublicKey(hashed_message, signature, recoveryBit);

    return getAddress(recoveredPublicKey);
}
