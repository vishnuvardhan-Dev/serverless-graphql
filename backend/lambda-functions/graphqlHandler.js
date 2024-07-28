const { ApolloServer } = require('apollo-server-lambda');
const typeDefs = require('../graphql-server/src/schema');
const resolvers = require('../graphql-server/src/resolvers');

const server = new ApolloServer({
  typeDefs,
  resolvers,
});

