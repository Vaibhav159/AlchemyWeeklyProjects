import { useState } from "react";
import { NFTCard } from "./components/nftCard";

const Home = () => {
  const apiKey = process.env.API_KEY;

  const [wallet, setWalletAddress] = useState(''); 
  const [collection, setCollectionAddress] = useState('');
  const [nfts, setNfts] = useState([]);
  const [fetchForCollection, setFetchForCollection] = useState(false);

  const requestOptions = {
    method: 'GET',
  };

 
  // create function to fetch nfts
  const fetchNfts = async () => {

    let nfts;
    console.log("Fetching NFTs");
    const baseURL = `https://eth-mainnet.alchemyapi.io/nft/v2/${apiKey}/getNFTs/`;
    let fetchURL;

    if(!collection.length){
      console.log("Fetching NFT's by wallet address");
      fetchURL = `${baseURL}?owner=${wallet}`;
    }
    else{
      console.log("Fetching NFT's by collection address");
      fetchURL = `${baseURL}?owner=${wallet}&contractAddresses%5B%5D=${collection}`;
    }

    nfts = await fetch(fetchURL, requestOptions).then(
      data => data.json()
    )

    if (nfts){
      console.log("NFTs fetched");
      setNfts(nfts.ownedNfts);
    }

  }

  // fetch nfts for collection
  const fetchNftsByCollection = async () => {
    console.log("Fetching NFT's by collection address");
    const baseURL = `https://eth-mainnet.alchemyapi.io/nft/v2/${apiKey}/getNFTsForCollection`;
    const fetchURL = `${baseURL}?contractAddress=${collection}&withMetadata=true`;

    if (!collection.length){
      console.log("No collection address provided");
      return;
    }

    const nfts = await fetch(fetchURL, requestOptions).then(
      data => data.json()
    )

    if (nfts){
      console.log("NFTs fetched by collection address");
      setNfts(nfts.nfts);
    }

  }

  return (
    <div className="flex flex-col items-center justify-center py-8 gap-y-3">
      <div className="flex flex-col w-full justify-center items-center gap-y-2">

        <input className="w-3/5 bg-slate-100 py-2 px-2 rounded-lg text-gray-800 focus:outline-blue-300 disabled:bg-slate-50 disabled:text-gray-50" 
          type={"text"} placeholder="Enter Wallet Address" 
          disabled={fetchForCollection}
          value={wallet} onChange={(e) => {
          setWalletAddress(e.target.value);
        }}/>

        <input className="w-3/5 bg-slate-100 py-2 px-2 rounded-lg text-gray-800 focus:outline-blue-300 disabled:bg-slate-50 disabled:text-gray-50"
          type={"text"} placeholder="Enter Collection Address" value={collection} onChange={(e) => {
          setCollectionAddress(e.target.value);
        }}/>

        <label className="text-gray-600">
          <input className="mr-2" type={"checkbox"} checked={fetchForCollection} onChange={
            (e) => {
              setFetchForCollection(e.target.checked);
            }
          }/>
          Fetch for collection
        </label>

        <button className={"disabled:bg-slate-500 text-white bg-blue-400 px-4 py-2 mt-3 rounded-sm w-1/5"} onClick={
          () => {
            if(fetchForCollection){
              fetchNftsByCollection();
            }
            else{
              fetchNfts();
            }
          }
        }>
          Search!!
        </button>
      </div>

      <div className="flex flex-wrap gap-y-12 mt-4 w-5/16 gap-x-2 justify-center">
        {
          nfts.length > 0 && nfts.map(nft => {
            return <NFTCard nft={nft}/>
          })
        }
      </div>
    </div>
  )
}

export default Home
