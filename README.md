__Disclaimer__

_This is a Proof of Concept only._

StableCoins
====

HUSD and HGLD are an Ether backed stablecoins pegged to the USD and Gold respectively.

Users can issue HUSD/HGLD by paying Ether into the contract. At a later date they
can withdraw Ether. If the price of Ether doubles and they withdraw they'll
receive half as much Ether as they deposited (The same amount in USD). The remaining ether is stored in the contract to cover losses when the price
falls.

When a user has deposited funds and the price falls two different things can happen. If the contract has the funds to pay the user it will do so (Eg. If you bought in 2 Ether and the price halved you'd get back 4 Ethers). If the contract doesn't have enough to fully cover the losses it will pay out proportionally to what it has left (eg If you bought in 2 Ethers and the price halved but the contract only had 2 Ethers it'd give you back 2 Ethers).


The StableCoins are deployed at the following addresses on the Rinkeby Testnet:

|  Token  |   Address    |
------------|---------------
| HUSD | [0x831848752f6589F544433b99D879b16ee2dC40cd](https://rinkeby.etherscan.io/address/0x831848752f6589F544433b99D879b16ee2dC40cd) |
HGLD  | [0x6f562dC573183b8c709Ba149d7a3eF2e60c472fF](https://rinkeby.etherscan.io/address/0x6f562dC573183b8c709Ba149d7a3eF2e60c472fF) |

Usage
-----

To issue tokens yourself:

1. Visit https://rinkeby.etherscan.io/address/0x831848752f6589F544433b99D879b16ee2dC40cd#code or https://rinkeby.etherscan.io/address/0x6f562dC573183b8c709Ba149d7a3eF2e60c472fF#code
2. Click on "Write Contract" from the navigations.
3. Click on "Connect to Web3" to connect your wallet.  
4. Under the listed functions choose "issue"
5. Enter the amount of ether you'd like to issue HUSD/HGLD.
6. Click on "Write"