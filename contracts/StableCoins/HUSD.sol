// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract HUSD is ERC20{

	AggregatorV3Interface internal priceFeed;



	constructor() ERC20("HussainUSD StableCoin ", "HUSD"){
		priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
	}

	function issue() 
		public 
		payable{
			uint amount = (msg.value * getLatestPrice());

			_mint(msg.sender, amount * 10**18);
	}

	/**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (uint) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return uint(price);
    }


    function withdraw(uint amount) public returns (uint){

	    require(amount <= balanceOf(msg.sender));
	    amountInWei = amount / getLatestPrice();

	    if(this.balance <= amountInWei) {
	      amountInWei = (amountInWei * this.balance * getLatestPrice() / (1 ether * _totalSupply);
	    }

	    balances[msg.sender] -= amount;
	    _totalSupply -= amount;
	    msg.sender.transfer(amountInWei);
	}
}