pragma solidity ^0.8.3;

contract DocumentRegistry {
    struct Document {
        string hash;
        uint256 dateAdded;
    }

    Document[] private documents;
    address contractOwner;

    modifier onlyOwner() {
        // Todo: Implementation
    }

    constructor() public {
        // Todo: Implementation
    }

    function add(string memory hash) public onlyOwner returns (uint256 dateAdded) {
        // Todo: Implementation
    }

    function getDocumentsCount() public view returns (uint256) {
        // Todo: Implementation
    }

    function getDocument(uint256 index) public view returns (string memory, uint256) {
        // Todo: Implementation
    }
}
