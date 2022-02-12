const HUSD = artifacts.require("HUSD");



module.exports = async function(callback) {

	try{
		const accounts = await web3.eth.getAccounts();
		const owner = accounts[0]

		const HUSDContract = await HUSD.new({from: owner});

		const test = await HUSDContract.issue({from: owner, value: web3.utils.toWei('0.04','ether')});
		const test2 = await HUSDContract.getLatestPrice({from:owner});
		const test3 = await HUSDContract.withdraw(50,{from:owner});

		console.log(test2.toNumber());
		console.log(test.receipt.status);
		console.log(test3.receipt.status);
	}

	catch(error){
		console.log(error);
	}

	callback();
}