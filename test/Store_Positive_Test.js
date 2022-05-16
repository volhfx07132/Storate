const Store = artifacts.require("Store");
var chaiAsPromised = require("chai-as-promised");
var chai = require("chai");
const { assert } = require("chai");
chai.use(chaiAsPromised);
var expect = chai.expect;
var store;

contract("Store contract", accounts => {
    describe("Start initialize smart contract", function() {
        it("Contract deployment", async() => {
            instanceSession = await Store.deployed();
            assert(instanceSession != undefined, "Smart contract should be defined");
        });
    })
})