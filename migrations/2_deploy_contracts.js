const AlchToken = artifacts.require('AlcToken');

module.exports = function (deployer) {
  deployer.deploy(AlchToken);
};
