import FireFly from "@hyperledger/firefly-sdk";

const firefly = new FireFly({ host: "http://localhost:5000" });

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
