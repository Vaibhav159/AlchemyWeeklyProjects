const axios = require('axios');
const niceList = require('../utils/niceList.json');
const MerkleTree = require('../utils/MerkleTree');

const serverUrl = 'http://0.0.0.0:1225';

const merkleTree = new MerkleTree(niceList);

async function main() {
  // TODO: how do we prove to the server we're on the nice list? 

  const userName = 'Norman Block';
  const index = niceList.findIndex(n => n === userName);
  const proof = merkleTree.getProof(index);

  await axios.post(`${serverUrl}/gift`, {
    // TODO: add request body parameters here!
    name: userName,
    proof: proof,
  }).then(res => console.log(res)).catch(err => console.log(err));

  // console.log({ gift });
}

main();