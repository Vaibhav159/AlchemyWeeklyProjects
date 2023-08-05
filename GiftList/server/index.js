const express = require('express');
const MerkleTree = require('../utils/MerkleTree');
const niceList = require('../utils/niceList');
const verifyProof = require('../utils/verifyProof');

const PORT = 1225;
const HOST = '0.0.0.0';

const app = express();
app.use(express.json());

// TODO: hardcode a merkle root here representing the whole nice list
// paste the hex string in here, without the 0x prefix

const merkleTree = new MerkleTree(niceList);
const MERKLE_ROOT = merkleTree.getRoot();

app.post('/gift', (req, res) => {
  // grab the parameters from the front-end here
  const body = req.body;

  console.log({ body });

  // if name is not in the body, set it to an empty string
  const userName = body.name || "";
  const proof = body.proof || "";

  console.log({ proof });

  const isInTheList = (verifyProof(proof, userName, MERKLE_ROOT));

  if(isInTheList) {
    // send the gift with the user's name
    res.send(`You got a gift! ${userName}`);
  }
  else {
    res.send("You are not on the list :(");
  }
  
});

app.get('/', (req, res) => {
  res.send('Hello User!')
})

app.listen(PORT, HOST, () => {
  console.log(`Running on http://${HOST}:${PORT}`);
});
