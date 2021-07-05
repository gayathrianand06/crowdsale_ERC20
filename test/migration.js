var crowdsale = artifacts.require("./crowdsale.sol");

module.exports = function(deployer) {
  const startTime = Math.round((new Date(Date.now() - 86400000).getTime())/1000); // Yesterdayconst endTime = Math.round((new Date().getTime() + (86400000 * 20))/1000); // Today + 20 days
  deployer.deploy(crowdsale, 
    startTime, 
    endTime,
    5, 
    "0x5AEDA56215b167893e80B4fE645BA6d5Bab767DE", 
  );
};
