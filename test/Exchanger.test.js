const { accounts, contract } = require('@openzeppelin/test-environment');
const { BN, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const Web3 = require("web3");

const Exchanger = contract.fromArtifact('Exchanger');
const DAI = contract.fromArtifact('DAI');


let exchanger;
let dai;

describe('Exchanger', function () {
    const [ owner ] = accounts;

    beforeEach(async function () {
        dai = await DAI.new(1000);

        exchanger = await Exchanger.new(dai.address);
    });

    it('.', async function () {
        const value = new BN('42');

        // Store a value
        // await this.box.store(42);

        // exchanger.depositEth().send({
        //     from: owner,
        //     value: Web3.utils.toWei("1", "ether"),
        // });

        await exchanger.depositEth({ value, from: owner });

        const balance = await exchanger.balance();

        console.log(balance);

        // expect(await this.box.retrieve()).to.be.bignumber.equal(value);

        // console.log(res);

        //web3.utils.toWei("10", "ether")

        // Test if the returned value is the same one
        // Note that we need to use strings to compare the 256 bit integers
        // expect((await this.box.retrieve()).toString()).to.equal('42');
    });
});
