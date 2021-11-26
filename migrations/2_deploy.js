const Exchanger = artifacts.require('Exchanger');

module.exports = async function (deployer) {
    await deployer.deploy(Exchanger);
};