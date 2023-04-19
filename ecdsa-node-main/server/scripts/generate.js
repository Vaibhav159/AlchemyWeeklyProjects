const secp = require("ethereum-cryptography/secp256k1");
const {toHex} = require("ethereum-cryptography/utils");
const {keccak256} = require("ethereum-cryptography/keccak");

const privateKey = secp.utils.randomPrivateKey();

const publicKey = secp.getPublicKey(privateKey);

const readablePublicKey = keccak256(publicKey.slice(1)).slice(-20);

// Prepare a message which have public key and private key that i can store in file
const message = JSON.stringify({
    publicKey: toHex(readablePublicKey),
    privateKey: toHex(privateKey)
})

const fs = require('fs');

fs.appendFile('message.txt', message, function (err) {
  if (err) throw err;
  console.log('Saved!');
});