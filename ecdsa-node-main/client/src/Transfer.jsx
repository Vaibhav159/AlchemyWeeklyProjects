import { useState } from "react";
import server from "./server";
import { signMessage, recoveryKeyAddress } from '/src/signMsg.js';

import detectEthereumProvider from '@metamask/detect-provider';


function Transfer({ address, setBalance, privateKey }) {
  const [sendAmount, setSendAmount] = useState("");
  const [recipient, setRecipient] = useState("");

  const setValue = (setter) => (evt) => setter(evt.target.value);

  async function transfer(evt) {
    evt.preventDefault();

    const msg = `I am signing my one-time nonce: ${sendAmount}`;

    const [signature, recoveryBit] = await signMessage(msg, privateKey);

    try {
      const {
        data: { balance },
      } = await server.post(`send`, {
        sender: address,
        amount: parseInt(sendAmount),
        recipient: recipient,
        signature: signature,
        recoveryBit: recoveryBit,
        msg: msg,
      });
      setBalance(balance);
    } catch (ex) {
      alert(ex.response.data.message);
    }
  }

  async function transferV2(evt){
    evt.preventDefault();

    const provider = await detectEthereumProvider();

    if (provider) {
      console.log('MetaMask is installed!');
    } else {
      alert('Please install MetaMask!');
    }

    const msg = `I am signing my one-time nonce: ${sendAmount}`;

    const signer = await provider.request({
      method: 'personal_sign',
      params: [msg, address, "Example password"]
    })

    console.log(signer);
    // get recoveryBit from signer
    const recoveryBit = signer.slice(130, 132);
    console.log(recoveryBit);

    try {
      const {
        data: { balance },
      } = await server.post(`send`, {
        sender : address,
        amount: parseInt(sendAmount),
        recipient: recipient,
        signature: signer,
        recoveryBit: recoveryBit,
        msg: msg,
      });
      setBalance(balance);
    }
    catch (ex) {
      alert(ex.response.data.message);
    }
  }

  return (
    <form className="container transfer" onSubmit={transferV2}>
      <h1>Send Transaction</h1>

      <label>
        Send Amount
        <input
          placeholder="1, 2, 3..."
          value={sendAmount}
          onChange={setValue(setSendAmount)}
        ></input>
      </label>

      <label>
        Recipient
        <input
          placeholder="Type an address, for example: 0x2"
          value={recipient}
          onChange={setValue(setRecipient)}
        ></input>
      </label>

      <input type="submit" className="button" value="Transfer" />
    </form>
  );
}

export default Transfer;
