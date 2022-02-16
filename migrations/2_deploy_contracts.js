const HUSD = artifacts.require("HUSD");
const HGLD = artifacts.require("HGLD");


module.exports = async function (deployer) {

  // Deploy HUSD
  deployer.deploy(HUSD);

  // Deploy HGLD
  deployer.deploy(HGLD);
};
