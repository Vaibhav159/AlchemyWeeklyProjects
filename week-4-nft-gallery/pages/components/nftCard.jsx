const NFTCard = ({nft}) => {
    return (

        <div className="w-1/4 flex flex-col ">

            <div className="rounded-md">
                <img className="object-cover h-128 w-full rounded-t-md" src={nft.media[0].gateway}></img>
            </div>

            <div className="flex flex-col y-gap-2 px-2 py-3 bg-slate-100 rounded-b-md h-110 ">

                <div>
                    <h2 className="text-xl text-gray-800">{nft.title}</h2>
                    <p className="text-gray-600">Id: {nft.id.tokenId.substr(nft.id.tokenId.length - 4)}</p>
                    <button className="cursor-pointer"
                    onClick={() =>  navigator.clipboard.writeText(nft.contract.address)}>
                        <p className="no-underline text-blue-600 hover:text-blue-800 visited:text-purple-600 cursor-pointer">
                            {nft.contract.address.substr(0,5)}...{nft.contract.address.substr(nft.contract.address.length - 4)}
                        </p>
                    </button>
                </div>

                <div className="flex-grow mt-2">
                    <p className="text-gray-600">{nft.description?.substr(0,150)}</p>
                </div>

                <div className="flex flex-wrap gap-y-12 mt-4 w-5/16 gap-x-2 justify-center">

                    <div>
                        <a className="py-2 px-4 bg-blue-500 w-2/6 rounded-sm text-white cursor-pointer"
                            target={"_blank"} href={nft.media[0].gateway}>View NFT</a>
                    </div>
                    
                    <div>
                        <a className="py-2 px-4 bg-blue-500 w-1/2 rounded-sm text-white cursor-pointer"
                            target={"_blank"} href={`https://etherscan.io/address/${nft.contract.address}`}>View Contract</a>
                    </div>

                </div>
            </div>

        </div>
    )
}

export default NFTCard;