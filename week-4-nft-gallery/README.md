# ROAD TO WEB3 Weekly Learning Challenges (Week 4)

This week's challenge is to create an NFT gallery using Alchemy's NFT API. Tutorial is found [here](https://docs.alchemy.com/alchemy/road-to-web3/weekly-learning-challenges/4.-how-to-create-an-nft-gallery-alchemy-nft-api).

## How does this gallery work?
By entering either a Ethereum wallet address or contract address you are able to fetch a list of owned NFT.

*Only NFTs minted on Ethereum's Mainnet will be fetched.* 

## Deploy your own

Deploy the example using [Vercel](https://vercel.com?utm_source=github&utm_medium=readme&utm_campaign=next-example) or preview live with [StackBlitz](https://stackblitz.com/github/vercel/next.js/tree/canary/examples/with-tailwindcss)

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/git/external?repository-url=https://github.com/vercel/next.js/tree/canary/examples/with-tailwindcss&project-name=with-tailwindcss&repository-name=with-tailwindcss)

## How to use

Execute [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app) with [npm](https://docs.npmjs.com/cli/init), [Yarn](https://yarnpkg.com/lang/en/docs/cli/create/), or [pnpm](https://pnpm.io) to bootstrap the example:

```bash
npx create-next-app --example with-tailwindcss with-tailwindcss-app
# or
yarn create next-app --example with-tailwindcss with-tailwindcss-app
# or
pnpm create next-app --example with-tailwindcss with-tailwindcss-app
```

Deploy it to the cloud with [Vercel](https://vercel.com/new?utm_source=github&utm_medium=readme&utm_campaign=next-example) ([Documentation](https://nextjs.org/docs/deployment)).


## How can I run this locally?

### Prerequisite 
* Log into [Alchemy](https://www.alchemy.com/) and create your own Ethereum Mainnet application. Save your API Key, you're going to need it. 


### Next
```bash
git clone https://github.com/Vaibhav159/AlchemyWeeklyProjects.git
cd into week_4_nft_gallery.
npm install
Create the .env.local file in your code editor
Add the "API_KEY" value with your own Alchemy Ethereum Mainnet App Api Key. 
Save .env.local
npm run dev
```