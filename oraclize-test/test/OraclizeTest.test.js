
const ganache = require('ganache-cli') // use ganache-cli with ethereum-bridge for Oraclize

// Configure web3 1.0.0 instead of the default version with Truffle
const Web3 = require('web3')
const provider = ganache.provider()
const web3 = new Web3(provider)

var myContract = artifacts.require("OraclizeTest");
myContract.deployed().then(function(instance) {return instance.getData.call()})
var contract_address = '0xa95d955c080269f5bcac6b1299a79a0abc3690c1';
module.exports = function() {
  
  var abi = [{"constant":false,"inputs":[{"name":"queryId","type":"bytes32"},{"name":"result","type":"string"}],"name":"__callback","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"myid","type":"bytes32"},{"name":"result","type":"string"},{"name":"proof","type":"bytes"}],"name":"__callback","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"data","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"update","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"inputs":[],"payable":true,"stateMutability":"payable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"description","type":"string"}],"name":"LognewOraclizeQuery","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"data","type":"string"}],"name":"LogData","type":"event"}];
  
  let contract = web3.eth.contract(abi).at(contract_address);
  contract.getData((err, res)=>{
    console.log('Data: '+res.toString());
  });
}
