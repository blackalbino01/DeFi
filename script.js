const HGLD = artifacts.require("HGLD");



module.exports = async function(callback) {

	try{
		const accounts = await web3.eth.getAccounts();
		const owner = accounts[0]

		const HGLDContract = await HGLD.new({from: owner});

		const test = await HGLDContract.issue({from: owner, value: web3.utils.toWei('0.2','ether')});
		const test2 = await HGLDContract.getDerivedPrice({from:owner});
		const test3 = await HGLDContract.withdraw(web3.utils.toWei('0.2','ether'),{from:owner});

		console.log(test2.toNumber());
		console.log(test.receipt.status);
		console.log(test3.receipt.status);
	}

	catch(error){
		console.log(error);
	}

	callback();
}