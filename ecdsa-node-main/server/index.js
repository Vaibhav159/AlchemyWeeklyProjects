const {recoveryKeyAddress} = require("./scripts/signMsg.js");

const ethers = require("ethers");
const express = require("express");
const app = express();
const cors = require("cors");
const port = 3042;

app.use(cors());
app.use(express.json());

const balances = {
  "0x2390290d94d3f7fb27576d8655272b9a65f69f5b": 100,
  "ac3bfb76cb8345047c26759495f955a72924d53a": 50,
  "76a6a2416e71b2072d0e647a8c74ed3fc7850dd4": 75,
};

app.get("/balance/:address", (req, res) => {
  const { address } = req.params;
  const balance = balances[address] || 0;
  res.send({ balance });
});

app.post("/send", (req, res) => {
  const { sender, recipient, amount, signature, recoveryBit, msg } = req.body;

  const signerAddr = ethers.verifyMessage(msg, signature).toUpperCase();

  console.log(signerAddr, sender, signerAddr !== sender)

  if (signerAddr !== sender.toUpperCase()) {
    res.status(400).send({ message: "Invalid signature!" });
  }

  // const sigValues = Object.keys(signature).map(function(key){
  //   return signature[key];
  // });

  // const finalSign = new Uint8Array(sigValues)

  // const derivedSender = recoveryKeyAddress(msg, finalSign, recoveryBit);

  // if (derivedSender !== sender) {
  //   res.status(400).send({ message: "Invalid signature!" });
  // }

  setInitialBalance(sender);
  setInitialBalance(recipient);

  if (balances[sender] < amount) {
    res.status(400).send({ message: "Not enough funds!" });
  } else {
    balances[sender] -= amount;
    balances[recipient] += amount;
    res.send({ balance: balances[sender] });
  }
});

app.listen(port, () => {
  console.log(`Listening on port ${port}!`);
});

function setInitialBalance(address) {
  if (!balances[address]) {
    balances[address] = 0;
  }
}
