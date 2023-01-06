# Code Challenge Test

## 1. smart contract that owner can mint NFT with all ERC721 features <br>
```bash
NFT.sol
```
Usage: `compile and deploy`
## 2. NFT Marketplace:
- **Creator** put his NFT for **Auction** with specific time and also cancel that before auction ends.
- After auction finished NFT transfer to highest bid address
- **Users** can place a bid 
```bash 
MohsenNFT.sol
Auction.sol
```
Usage:
- [ 1 ] compile and deploy `MohsenNFT.sol`
- [ 2 ] compile and deploy `Auction.sol`
- [ 3 ] minNFT with `wallet address` and `tokenURI` optional
- [ 4 ] approve in `setApproveForAll` of deployed `MohsenNFT.sol` with auction contract address
- [ 5 ] start auction
- [ 6 ] place a bid with different `wallet`, cancel and so on.


<br>

### Tested in goearli testnet
[[goearli faucet](https://goerli-faucet.pk910.de/)]
