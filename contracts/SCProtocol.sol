// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;
import '@openzeppelin/contracts/access/Ownable.sol';

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract SCProtocol is Ownable {
    mapping(string=>address) admins;
    enum WorkerType{
        Person,
        IOT
    }
    struct Worker{
    string name;
    WorkerType workerType;
    string email;
    string contact;
    }
    uint256 latestWorkerID;
    mapping(uint256=>Worker) workers;

    struct Location{
    string district;
    string subDistrict;
    string details;
    }

    bytes[] allLocationHashes;

    mapping(bytes=>Location) locations;

    struct Product{
        uint256 productId;
        string productName;
        uint256 productPrice;
        string description;
        string unit;
        uint256 amount; 
    } 

    Product[] products;
    enum LocationType{
        Production,
        Warehouse,
        Retail
    }

    enum Status{
        Pending,
        Complete,
        Damaged,
        Details
    }

    struct SupplyChainStage{
        uint256 workerID;
        LocationType locationType;
        bytes locationHash;
        uint256 expectedPickUpdate;  
        uint256 price;
        Status status; 
        string statusDetails;
    }

    uint256 latestProjectId;

    struct Project{
        string projectName;
        uint256 startDate;
        uint256 endDate;
        uint256 productId;
        uint256 quantity;
        string unit;
        SupplyChainStage[] supplyChainStages;
    }
    // project ID -> array of Project
    mapping(uint256=>Project) projects; 

    function addAdmin() external onlyOwner{

    }

    function isAdmin(address addressToCheck) external returns(bool){

    }

    function addWorker(WorkerType workerType, string memory name, string memory email, string memory contact ) external onlyAdmin {

    }

    function addLocation(string memory district, string memory subdistrict, string memory details) external onlyAdmin {

    }

    function addProduct(string memory name, string memory description, string memory productId, string memory unit, uint256 amount) external onlyAdmin {

    }

    function getAllProducts() external returns(Product[] memory) {
        
    }

    function getAllLocations() external returns(Location[] memory) {

    }

    function addProject(Project project) external onlyAdmin {

    }

    function updateProjectStatus(uint256 projectId, uint256 supplyChainLevel, Status currentStatus, statusDetails) external {

    }

    function getProject() external returns(Project[] memory) {

    }
}
