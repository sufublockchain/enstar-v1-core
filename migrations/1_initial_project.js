const EnstarV1Project = artifacts.require("EnstarV1Project");
const ERC20FixedSupply = artifacts.require("ERC20FixedSupply");
const EnstarV1Factory = artifacts.require("EnstarV1Factory");


module.exports = async function(deployer) {
    await deployer.deploy(ERC20FixedSupply,
        "My Test Coin","MTC",18,1000000000);
    const uni_fund = await ERC20FixedSupply.deployed();
    await deployer.deploy(EnstarV1Project, uni_fund.address);
    await deployer.deploy(EnstarV1Factory, uni_fund.address);
};