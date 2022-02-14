// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract HGLD is ERC20{

	using SafeMath for uint;

	address internal _base = 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e;
	address internal _quote = 0x81570059A0cb83888f1459Ec66Aad1Ac16730243;
	uint8 internal _decimals = 8;

	uint public ethCollateralFactor = 7500;



	constructor() ERC20("HussainGLD StableCoin ", "HLD"){}

	function issue() external payable{
		uint collateralValue = ethCollateralFactor.mul(msg.value);
		uint amount = (collateralValue.mul(getLatestPrice())).div(1 ether);
		_mint(msg.sender, amount);
	}

	/**
     * Returns the latest price
     */
    function getDerivedPrice() public view returns (uint){

        uint decimals = 10 ** uint(_decimals);
        ( , int basePrice, , , ) = AggregatorV3Interface(_base).latestRoundData();
        uint8 baseDecimals = AggregatorV3Interface(_base).decimals();
        basePrice = scalePrice(basePrice, baseDecimals);

        ( , int quotePrice, , , ) = AggregatorV3Interface(_quote).latestRoundData();
        uint8 quoteDecimals = AggregatorV3Interface(_quote).decimals();
        quotePrice = scalePrice(quotePrice, quoteDecimals);

        return (uint(basePrice).mul(decimals)).div(uint(quotePrice));
    }


    function scalePrice(int _price, uint8 _priceDecimals)
        internal
        pure
        returns (int)
    {
        if (_priceDecimals < _decimals) {
            return _price.mul(int(10 ** uint(_decimals.sub(_priceDecimals))));
        } else if (_priceDecimals > _decimals) {
            return _price.div(int(10 ** uint(_priceDecimals.sub(_decimals))));
        }
        return _price;
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