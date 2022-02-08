const HUSD = artifacts.require("HUSD");



module.exports = async function(callback) {

	try{
		const accounts = await web3.eth.getAccounts();
		const owner = accounts[1]

		const HUSDContract = await HUSD.new({from: owner});

		const test = await swapTokens.swap(DAI, WETH, amountIn, {from: trader})

		console.log(test.receipt.status)
	}

	catch(error){
		console.log(error);
	}

	callback();
}