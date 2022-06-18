export const Pagination = ({nftPerPage, totalNfts, hide}) => {

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
            <ul class="inline-flex -space-x-px">
                {
                    pageNumbers.map(number => (
                        <li key={number}>
                            <a className="px-4 py-2 text-gray-700 bg-gray-200 rounded-md hover:bg-blue-400 hover:text-white" href={`#${number}`}>{number}</a>
                        </li>
                    ))
                }
            </ul>
        </nav>
    );
}