const secp = require("ethereum-cryptography/secp256k1");
const {toHex} = require("ethereum-cryptography/utils");

const privateKey = secp.utils.randomPrivateKey();

const fs = require('fs');

fs.appendFile('message.txt', toHex(privateKey), function (err) {
  if (err) throw err;
  console.log('Saved!');
});