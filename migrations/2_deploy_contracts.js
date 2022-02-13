const HUSD = artifacts.require("HUSD");


module.exports = async function (deployer) {

  // Deploy HUSD
  deployer.deploy(HUSD);
};
