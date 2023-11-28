const path = require("path");
const fs = require("fs");
const solc = require("solc");


const walletPath = path.join(__dirname, "contracts", "Wallet.sol");
const source = fs.readFileSync(walletPath, "utf8");
var input = {
    language: 'Solidity',
    sources: {
        'Wallet.sol' : {
            content: source
        }
    },
    settings: {
        outputSelection: {
            '*': {
                '*': [ '*' ]
            }
        }
    }
}; 
compiledCode = (JSON.parse(solc.compile(JSON.stringify(input))));
const bytecode = compiledCode.contracts['Wallet.sol']['Wallet'].evm.bytecode.object;

// Write the bytecode to a new file
const bytecodePath = path.join(__dirname, 'WalletContractBytecode.bin');
fs.writeFileSync(bytecodePath, bytecode);

// Log the compiled contract code to the console
console.log('Contract Bytecode:\n', bytecode);

// Get the ABI from the compiled contract
const abi = compiledCode.contracts['Wallet.sol']['Wallet'].abi;

// Write the Contract ABI to a new file
const abiPath = path.join(__dirname, 'WalletContractAbi.json');
fs.writeFileSync(abiPath, JSON.stringify(abi, null, '\t'));
