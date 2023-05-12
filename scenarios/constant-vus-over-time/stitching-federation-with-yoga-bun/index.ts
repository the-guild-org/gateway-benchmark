import { createYoga } from "graphql-yoga";
import { getStitchedSchemaWithUrls } from "@graphql-tools/federation";

async function main() {
  const schema = await getStitchedSchemaWithUrls([
    {
      endpoint: "http://accounts:4001/graphql",
    },
    {
      endpoint: "http://reviews:4004/graphql",
    },
    {
      endpoint: "http://products:4003/graphql",
    },
    {
      endpoint: "http://inventory:4002/graphql",
    },
  ]);
  const yoga = createYoga({ schema });
  const port = process.env.PORT ? parseInt(process.env.PORT) : 4000;
  Bun.serve({
    port,
    fetch: yoga,
  });
}

main().catch(console.error);
