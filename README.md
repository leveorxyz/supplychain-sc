# Hyperledger Firefly Berger Supply Chain Demo

### Preresuisite
```
node 15+
npm
ts-node
```
```
sudo apt-get update
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install solc
npm i -g ts-node
```

### Orgs 
Org1 - sc1
Org2 - sc2

<Stack Name> - berger

### Commands

- Setup firefly:
```
ff init --prompt-names
```
- Start 
```
ff start demo
```
- Compile contract. (Assuming you are in the root directory)
```
cd contracts
solc --combined-json abi,bin SCProtocol.sol > ../abi/compiled.json
```
- Deploy contract. (Assuming you are in the root directory)
```
cd abi
ff deploy ethereum berger compiled.json
```
- Copy abi from `sc_protocol.json` and register the apis through firefly interface. (http://127.0.0.1:5109)
- Create api namespace `SCProtocol` through firefly interface. 
- To initialize the data use the following command:
```
ts-node scripts/seed.ts
```