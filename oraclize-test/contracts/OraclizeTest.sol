pragma solidity ^0.4.19;

//Importing the Oraclize contract
import "installed_contracts/oraclize-api/contracts/usingOraclize.sol";

contract OraclizeTest is usingOraclize {
    
    //Defining variables
    mapping(bytes32 => bool) validIds; //To validate Query IDs
    uint constant gasLimitForOraclize = 175000; //Gas limit for Oraclize callback
    
    //Events to track contract actions
    event newOraclizeQuery(string description);
    event newData(string data);
    
    //Constructor  
    constructor() public payable {

        OAR = OraclizeAddrResolverI(0x3B4CFb718b4743859a804e1a36BE2Af48eA700e6);
        //Setting Oraclize proof type
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        
        //Setting gasPrice for Oraclize callback
        oraclize_setCustomGasPrice(1000000000 wei); //1 Gwei
        update(); 
    }
    
    function __callback(bytes32 queryId, string result, bytes proof) public {
        
        //Only Oraclize should be able to call this function
        require(msg.sender == oraclize_cbAddress());
        //Validate the ID
        require(validIds[queryId]);
        emit newData(result);
        //To ensure the callback for a given ID is never called twice
        validIds[queryId] = false;
    }
  
    function update() public payable {  
        
        //Require ETH to cover callback gas costs
        require(msg.value >= 0.000175 ether); //175,000 gas * 1 Gwei
        
        if (oraclize_getPrice("URL") > address(this).balance) {
            emit newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            emit newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
        
            //sending query
            bytes32 queryId = oraclize_query("URL", "json(http://variusworldtech.com/results.json).$[1].email", gasLimitForOraclize);
        
            //Adding query ID to mapping
            validIds[queryId] = true;
            
        }
    }
}