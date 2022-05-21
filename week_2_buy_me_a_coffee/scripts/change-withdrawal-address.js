// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

// Returns the Ether Balance of the given address
async function getEtherBalance(address) {
  const balance = await hre.waffle.provider.getBalance(address);
  return hre.ethers.utils.formatEther(balance);
}

// Logs the Ether Balance for the list of addresses
async function logEtherBalances(addresses) {
  for (const address of addresses) {
    const balance = await getEtherBalance(address);
    console.log(`Ether balance of ${address}: ${balance}`);
  }
}

// Logs the memos stores on chain for the given coffee purchases
async function logMemos(memos) {
  for (const memo of memos) {
    // convert unix memo.timestamp to human readable date
    const timestamp = new Date(memo.timestamp * 1000);
    const from = memo.sender;
    const name = memo.name;
    const message = memo.message;
    console.log(`${timestamp}: Tipper ${name}(${from}) says: ${message}`);
  }
}


async function main() {
  // Base coffee price
  const price = {value : hre.ethers.utils.parseEther("0.001")};
  const large_price = {value : hre.ethers.utils.parseEther("0.003")};

  console.log(price);

  // Get example accounts
  const [owner, tipper1, tipper2, tipper3] = await hre.ethers.getSigners();

  // Get the contract to deploy and deploy it.
  const BuyMeACoffee = await hre.ethers.getContractFactory("BuyMeACoffee");
  const buyMeACoffee = await BuyMeACoffee.deploy();
  await buyMeACoffee.deployed();

  console.log(`Deployed BuyMeACoffee at ${buyMeACoffee.address}`);

  // Check the initial balances
  const balances = [
    owner.address,
    tipper1.address,
    buyMeACoffee.address,
    tipper2.address
  ];

  console.log("Initial balances:");
  await logEtherBalances(balances);

  // Buy some coffee's
  await buyMeACoffee.connect(tipper1).buyCoffee("Jack", "Good stuff!!", price);
  await buyMeACoffee.connect(tipper2).buyCoffee("Harley", "Keep going!!", price);
  await buyMeACoffee.connect(tipper3).buyCoffee("Manace", "GOAT", price);

  // Check balance after coffee purchase
  console.log("Final balances:");
  await logEtherBalances(balances);

  // Withdraw the tips
  await buyMeACoffee.connect(owner).withdrawTipsFromContractToOwner();

  // Check the balances again after tips are withdrawn
  console.log("Final balances after tips are withdrawn:");
  await logEtherBalances(balances);

  // Check the memos
  const memos = await buyMeACoffee.getMemos();
  console.log("== memos ==");
  logMemos(memos);

  // Change the withdrawal address
  await buyMeACoffee.connect(owner).setWithdrawAddress(tipper1.address);

  await buyMeACoffee.connect(tipper2).buyCoffee("Harley", "Keep going!!", price);
  await buyMeACoffee.connect(tipper2).buyCoffee("Harley", "Keep going!!", price);
  await buyMeACoffee.connect(tipper2).buyLargeCoffee("Harley Larger", "Keep going!!", large_price);

  console.log("Balance after new withdrawal address");

  await logEtherBalances(balances);

  // Withdraw the tips ofr tipper1
  await buyMeACoffee.connect(tipper1).withdrawTipsFromContractToOwner();  

  console.log("Balance after tips are withdrawn for tipper1");
  await logEtherBalances(balances);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
