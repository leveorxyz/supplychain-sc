import FireFly from "@hyperledger/firefly-sdk";
import {
  randCity,
  randText,
  randAddress,
  Address,
  randProduct,
  randUuid,
  randNumber,
  randFullName,
  randPhoneNumber,
} from "@ngneat/falso";
import { PromisePool } from "@supercharge/promise-pool";
import keccak256 from "keccak256";

const firefly = new FireFly({ host: "http://localhost:5000" });

const invokeFirefly = async (
  inputs: { [key: string]: any }[],
  func: string
) => {
  const { results, errors } = await PromisePool.withConcurrency(5)
    .for(inputs)
    .process(async (input: { [key: string]: any }) => {
      return await firefly.invokeContractAPI("SCProtocol", func, {
        input,
      });
    });
  return { results, errors };
};

const queryFirefly = async (func: string, params: { [key: string]: any }) => {
  return await firefly.queryContractAPI("SCProtocol", func, params);
};

const seedAddress = async (count: number, email: string) => {
  const districts = randCity({ length: count });
  const subDistricts = randAddress({ length: count }).map(
    (addr: Address) => addr.county
  );
  const details = randText({ length: count });
  const inputs = [];
  for (let i = 0; i < count; i++) {
    inputs.push({
      district: districts[i],
      subdistrict: subDistricts[i],
      details: details[i],
      email: email,
    });
  }
  return await invokeFirefly(inputs, "addLocation");
};

const seedProducts = async (count: number, email: string) => {
  let inputs = [];
  for (let i = 0; i < count; i++) {
    let product = randProduct();
    inputs.push({
      name: product.title,
      description: product.description,
      productId: randUuid(),
      unit: randUuid(),
      price: randNumber(),
      amount: randNumber(),
      email: email,
    });
  }
  return await invokeFirefly(inputs, "addProduct");
};

const seedWorkers = async (count: number, email: string) => {
  let inputs = [];
  for (let i = 0; i < count; i++) {
    inputs.push({
      workerType: Math.round(Math.random()),
      name: randFullName(),
      email: email,
      contact: randPhoneNumber(),
    });
  }
  return await invokeFirefly(inputs, "addWorker");
};

const generateSupplyChainStage = (
  count: number,
  workerCount: number,
  locations: { [key: string]: string }[]
) => {
  const stages = [];
  const statuses = [2, 1, 0];
  for (let i = 0; i < count; i++) {
    let locationIndex = randNumber({ min: 0, max: locations.length - 1 });
    stages.push({
      workerID: randNumber({ min: 0, max: workerCount - 1 }),
      locationType: i,
      locationHash:
        "0x" +
        keccak256(
          locations[locationIndex].district +
            locations[locationIndex].subdistrict +
            locations[locationIndex].details +
            locations[locationIndex].email
        ).toString("hex"),
      expectedPickUpdate: Math.round(Date.now() / 1000) + (i + 1) * 86400 * 2,
      price: randNumber(),
      status: statuses[i],
      statusDetails: randText(),
    });
  }
  return stages;
};

const seedProjects = async (count: number, email: string) => {
  let inputs = [];
  const workerCount = 10;
  const locations = (await queryFirefly("getAllLocations", {})).output;
  for (let i = 0; i < count; i++) {
    let supplyChainStages = generateSupplyChainStage(
      3,
      workerCount,
      locations as { [key: string]: string }[]
    );
    inputs.push({
      project: {
        projectName: randProduct().title,
        startDate: Math.round(Date.now() / 1000),
        endDate: Math.round(Date.now() / 1000) + 864000,
        productId: randNumber(),
        quantity: randNumber(),
        unit: randUuid(),
        supplyChainStages: supplyChainStages,
      },
      email: email,
    });
  }
  return await invokeFirefly(inputs, "addProject");
};

(async () => {
  const email = "contact@leveor.xyz";
  const owner = (await firefly.queryContractAPI("SCProtocol", "owner", {}, {}));
  console.log(owner);
  
  // await firefly.invokeContractAPI("SCProtocol", "addAdmin", {
  //   input: {
  //     email,
  //     adminAddress: owner,
  //   },
  // });

  // const isAdmin = (
  //   await firefly.queryContractAPI("SCProtocol", "isAdmin", {
  //     input: {
  //       email,
  //     },
  //   })
  // ).output;

  // if (!isAdmin) {
  //   throw new Error("Email not admin");
  // }

  // const resAddress = await seedAddress(10, email);
  // console.log("Addresses seeded:", resAddress.results.length);

  // const resProducts = await seedProducts(10, email);
  // console.log("Products seeded:", resProducts.results.length);

  // const resWorkers = await seedWorkers(10, email);
  // console.log("Workers seeded:", resWorkers.results.length);

  // const resProjects = await seedProjects(10, email);
  // console.log("Projects seeded:", resProjects.results.length);
})();
