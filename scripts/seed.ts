import FireFly from "@hyperledger/firefly-sdk";
import { randCity, randText, randAddress, Address } from "@ngneat/falso";

const firefly = new FireFly({ host: "http://localhost:5000" });

const seedAddress = async (count: number) => {
  const districts = randCity({ length: count });
  const subDistricts = randAddress({ length: count }).map(
    (addr: Address) => addr.county
  );
  const details = randText({ length: count });
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
})();
