// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract HUSD is ERC20{

	using SafeMath for uint;

	AggregatorV3Interface internal priceFeed;
	uint public ethCollateralFactor = 7500;



	constructor() ERC20("HussainUSD StableCoin ", "HUSD"){
		priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
	}

	function issue() public payable{
		uint collateralValue = ethCollateralFactor.mul(msg.value);
		uint amount = (collateralValue.mul(getLatestPrice())).div(1 ether);
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
        return uint(price).div(10**8);
    }


    function withdraw(uint HUSDAmount) public returns (uint){

	    require(HUSDAmount <= balanceOf(msg.sender));
	    uint ethAmount = (HUSDAmount.mul(1 ether)).div(getLatestPrice());

	    // If we don't have enough Ether in the contract to pay out the full amount
	    // pay an amount proportinal to what we have left.
	    // this way user's net worth will never drop at a rate quicker than
	    // the collateral itself.

	    // For Example:
	    // A user deposits 1 Ether when the price of Ether is $300
	    // the price then falls to $150.
	    // If we have enough Ether in the contract we cover the losses
	    // and pay them back 1.5 ether (the same amount in USD).
	    // if we don't have enough money to pay them back we pay out
	    // proportonailly to what we have left. In this case they'd
	    // get back 0.75 Ether.

	    if(address(this).balance <= ethAmount) {
	      ethAmount = 
	      (ethAmount.mul(address(this).balance).mul(getLatestPrice())).div(totalSupply().mul(1 ether));
	    }

	    _burn(msg.sender, HUSDAmount.mul(10**4));
	    payable(msg.sender).transfer(ethAmount);
	}
}