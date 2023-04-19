import server from "./server";
import * as secp from 'ethereum-cryptography/secp256k1';
import * as keccak from 'ethereum-cryptography/keccak';
import * as utils from 'ethereum-cryptography/utils';

import detectEthereumProvider from '@metamask/detect-provider';

function startApp(provider) {
  // If the provider returned by detectEthereumProvider isn't the same as
  // window.ethereum, something is overwriting it – perhaps another wallet.
  if (provider !== window.ethereum) {
    console.error('Do you have multiple wallets installed?');
  }
  // Access the decentralized web!
  console.log('Ethereum successfully detected!', provider);
  return provider;
}

function Wallet({ address, setAddress, balance, setBalance, privateKey, setPrivateKey }) {
  async function onChange(evt) {
    const privateKey = evt.target.value;
    setPrivateKey(privateKey);

    let address = secp.getPublicKey(privateKey);

    address = keccak.keccak256(address.slice(1)).slice(-20);

    address = utils.toHex(address)

    setAddress(address);

    if (address) {
      const {
        data: { balance },
      } = await server.get(`balance/${address}`);
      setBalance(balance);
    } else {
      setBalance(0);
    }
  }

  async function onClickToMetaMask(evt) {
    evt.preventDefault();
    const provider = await detectEthereumProvider();

    if (provider) {
      // From now on, this should always be true:
      // provider === window.ethereum
      startApp(provider); // initialize your app
    } else {
      console.log('Please install MetaMask!');
    }

    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' })
    .catch((err) => {
      if (err.code === 4001) {
        // EIP-1193 userRejectedRequest error
        // If this happens, the user rejected the connection request.
        console.log('Please connect to MetaMask.');
      } else {
        console.error(err);
      }
    });

    console.log(accounts);
    const address = accounts[0];
    console.log(address);
    setAddress(address);

    if (address) {
      const {
        data: { balance },
      } = await server.get(`balance/${address}`);
      console.log(balance, address);
      setBalance(balance);
      setPrivateKey("");
    } else {
      setBalance(0);
    }
  }

  return (
    <div className="container wallet">
      <h1>Your Wallet</h1>

      <label>
        Private Key
        <input placeholder="Type your private key" value={privateKey} onChange={onChange}></input>
      </label>

      <div className="balance">Balance: {balance}</div>

      <div className="address">Address: {address}</div>

      <input type="button" className="button" value="Connect to MetaMask" onClick={onClickToMetaMask} />
    </div>
  );
}

export default Wallet;
