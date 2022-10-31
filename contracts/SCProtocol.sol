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
        string subdistrict;
        string details;
    }

    bytes32[] allLocationHashes;

    mapping(bytes32=>Location) locations;

    struct Product{
        uint256 productId;
        string productName;
        uint256 productPrice;
        string description;
        string unit;
        uint256 amount; 
    } 

    mapping(string=>Product) products;
    string[] productIDs;
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

    function isAdmin(string memory email) public view returns(bool){
        return admins[email] != address(0); 
    }

    function addWorker(WorkerType workerType, string memory name, string memory email, string memory contact ) external onlyAdmin(email) {
          Worker storage worker = workers[latestProjectId];
          worker.workerType = workerType; 
          worker.name = name; 
          worker.email = email; 
          worker.contact = contact; 
          latestProjectId++;
    }

    function addLocation(string memory district, string memory subdistrict, string memory details, string memory email) external onlyAdmin(email) {
       bytes32 hashOfData = keccak256(abi.encodePacked(district, subdistrict, details, email)); 
       Location storage location = locations[hashOfData];
       location.district = district;
       location.subdistrict = subdistrict;
       location.details = details;
       allLocationHashes.push(hashOfData);
    }

    function addProduct(string memory name, string memory description, string memory productId, string memory unit, uint256 amount, uint256 price, string memory email) external onlyAdmin(email) {
        require(products[productId].amount != 0, "Product ID already exist");
        Product storage product = products[productId];
        product.productName = name;
        product.description = description;
        product.unit = unit;
        product.amount = amount;
        product.productPrice = price;
        productIDs.push(productId);

    }

    function getAllProducts() external view returns(Product[] memory) {
        uint256 numberOfProducts = productIDs.length;
        Product[] memory allProducts = new Product[](numberOfProducts);
        for (uint256 index = 0; index < numberOfProducts; index++) {
            Product storage product = products[productIDs[index]];
            allProducts[index] = product;
        }
        return allProducts;
    }

    function getAllLocations() external view returns(Location[] memory) {
        uint256 numberOfLocations = allLocationHashes.length;
        Location[] memory allLocations = new Location[](numberOfLocations);
        for (uint256 index = 0; index < numberOfLocations; index++) {
            Location storage location = locations[allLocationHashes[index]];
            allLocations[index] = location;
        }
        return allLocations;
    }

    function getAllWorkers() external view returns(Worker[] memory){
        Worker[] memory allWorkers = new Worker[](latestWorkerID);
        for (uint256 index = 0; index < latestWorkerID; index++) {
            Worker storage worker = workers[index];
            allWorkers[index] = worker;
        }
        return allWorkers;
    }

    function addProject(Project memory project, string memory email) external onlyAdmin(email) {
        Project storage newProject = projects[latestProjectId];
        newProject.supplyChainStages = project.supplyChainStages;
        newProject.productId = project.productId;
        newProject.projectName = project.projectName;
        newProject.startDate = project.startDate;
        newProject.endDate = project.endDate;
        newProject.quantity = project.quantity;
        newProject.unit = project.unit;
        latestProjectId++;
    }

    function updateProjectStatus(uint256 projectId, uint256 supplyChainLevel, Status currentStatus, string memory statusDetails) external {
        require(projectId<latestProjectId, "Project ID do not exist");
         projects[projectId].supplyChainStages[supplyChainLevel].status = currentStatus;
         projects[projectId].supplyChainStages[supplyChainLevel].statusDetails = statusDetails;
    }

    function getProject() external returns(Project[] memory) {

    }
}
