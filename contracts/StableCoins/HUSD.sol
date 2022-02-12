// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract HUSD is ERC20{

	AggregatorV3Interface internal priceFeed;
	uint public ethCollateralFactor = 7500;



	constructor() ERC20("HussainUSD StableCoin ", "HUSD"){
		priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
	}

	function issue() 
		public 
		payable{

			uint collateralValue = (msg.value * ethCollateralFactor);
			uint amount = (collateralValue * getLatestPrice()) / 1 ether;

			_mint(msg.sender, amount);
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
        return uint(price/10**8);
    }


    function withdraw(uint HUSDAmount) public returns (uint){

	    require(HUSDAmount <= balanceOf(msg.sender));
	    uint ethAmount = (HUSDAmount * 1 ether) / getLatestPrice();

	    if(address(this).balance <= ethAmount) {
	      ethAmount = (ethAmount * address(this).balance * getLatestPrice()) / (totalSupply() * 1 ether);
	    }

	    _burn(msg.sender, (HUSDAmount * 10**4));
	    payable(msg.sender).transfer(ethAmount);
	}
}