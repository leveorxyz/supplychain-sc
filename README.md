# Hyperledger Firefly Berger Supply Chain Demo

### Preresuisite
```
sudo apt-get update
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install solc
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
solc --combined-json abi,bin SCProtocol.sol > ../abi/compiled.json --base-path '/' --include-path 'node_modules/'
```
- Deploy contract. (Assuming you are in the root directory)
```
cd abi
ff deploy ethereum berger compiled.json
```
- Copy abi from `sc_protocol.json` and register the apis through firefly interface.
- Create api namespace `SCProtocol`