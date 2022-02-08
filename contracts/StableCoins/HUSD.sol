// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract HUSD is ERC20{

	AggregatorV3Interface internal priceFeed;
	uint public collateralized ratio = 11000;

	//the CDP can be in 4 states, Issued, Funded, Withdrawn, Liquidated 
	//here i define only three because in the latter two- the contract is destructed
	enum CDPStates{Issued, Funded, Withdrawn};

	CDPStates public state;

	constructor() ERC20("HussainUSD StableCoin ", "HUSD"){
		priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
	}

	//modifier that prevents some functions to be called
	// in any other state that the provided one
	modifier onlyState(CDPStates expectedState){
		require(state == expectedState, "Not allowed in this state");
		_;
	}

	function issue() 
		public 
		payable  
		onlyState(state.Funded){

	}

	/**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int) {
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }
}