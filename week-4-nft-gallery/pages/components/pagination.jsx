export const Pagination = ({nftPerPage, totalNfts, hide, fetchNftsByCollection}) => {
    console.log(fetchNftsByCollection)

    if (hide){
        return(
            <div></div>
        )
    }
    
    const pageNumbers = [];

    for (let i = 1; i <= Math.ceil(totalNfts / nftPerPage); i++) {
        pageNumbers.push(i);
    }

    return (
        <nav>
            <ul class="flex flex-wrap gap-y-12 mt-4 w-5/16 gap-x-2 justify-center">
                {
                    pageNumbers.map(number => (
                        <li key={number}>
                            <a className="px-4 py-2 text-gray-700 bg-gray-200 rounded-md hover:bg-blue-400 hover:text-white" 
                            href={`#${number}`} onClick={
                                () => {
                                    console.log("fetching page: " + number, number * nftPerPage);
                                    fetchNftsByCollection(number * nftPerPage);
                                }
                            }>
                                {number}
                            </a>
                        </li>
                    ))
                }
            </ul>
        </nav>
    );
}