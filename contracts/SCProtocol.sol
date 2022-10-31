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

    modifier onlyAdmin(string memory email) {
        require(admins[email] != address(0), "Not an admin");
        _;
    }

    function addAdmin(string memory email, address adminAddress) external onlyOwner{
        require(admins[email] != adminAddress, "Already a admin");
        admins[email] = adminAddress;
    }

    function isAdmin(string memory email) external returns(bool){
        return admins[email] != address(0); 
    }

    function addWorker(WorkerType workerType, string memory name, string memory email, string memory contact ) external onlyAdmin(email) {

    }

    function addLocation(string memory district, string memory subdistrict, string memory details, string memory email) external onlyAdmin(email) {

    }

    function addProduct(string memory name, string memory description, string memory productId, string memory unit, uint256 amount, string memory email) external onlyAdmin(email) {

    }

    function getAllProducts() external returns(Product[] memory) {
        
    }

    function getAllLocations() external returns(Location[] memory) {

    }

    function addProject(Project memory project, string memory email) external onlyAdmin(email) {

    }

    function updateProjectStatus(uint256 projectId, uint256 supplyChainLevel, Status currentStatus, string memory statusDetails) external {

    }

    function getProject() external returns(Project[] memory) {

    }
}
