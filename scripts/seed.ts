import FireFly from "@hyperledger/firefly-sdk";
import { randCity, randText, randAddress, Address } from "@ngneat/falso";
import { PromisePool } from "@supercharge/promise-pool";

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

(async () => {
  const email = "contact@leveor.xyz";
  const owner = (await firefly.queryContractAPI("SCProtocol", "owner", {}, {}))
    .output;
  await firefly.invokeContractAPI("SCProtocol", "addAdmin", {
    input: {
      email,
      adminAddress: owner,
    },
  });

  const isAdmin = (
    await firefly.queryContractAPI("SCProtocol", "isAdmin", {
      input: {
        email,
      },
    })
  ).output;

  if (!isAdmin) {
    throw new Error("Email not admin");
  }

  const resAddress = await seedAddress(10, email);
  console.log("Addresses seeded:", resAddress.results.length);
})();
