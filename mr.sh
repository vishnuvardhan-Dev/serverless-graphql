# Populate frontend files
cat << EOF > frontend/react-app/src/App.js
import React from 'react';
import { ApolloClient, InMemoryCache, ApolloProvider, useQuery, gql } from '@apollo/client';

const client = new ApolloClient({
  uri: process.env.REACT_APP_GRAPHQL_ENDPOINT,
  cache: new InMemoryCache()
});

const GET_HELLO = gql\`
  query {
    hello
  }
\`;

function HelloWorld() {
  const { loading, error, data } = useQuery(GET_HELLO);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error :(</p>;

  return <h1>{data.hello}</h1>;
}

function App() {
  return (
    <ApolloProvider client={client}>
      <div className="App">
        <HelloWorld />
      </div>
    </ApolloProvider>
  );
}

export default App;
EOF

echo "REACT_APP_GRAPHQL_ENDPOINT=http://localhost:4000/graphql" > frontend/react-app/.env

# Populate backend files
cat << EOF > backend/graphql-server/src/schema.js
const { gql } = require('apollo-server');

const typeDefs = gql\`
  type Query {
    hello: String
  }
\`;

module.exports = typeDefs;
EOF

cat << EOF > backend/graphql-server/src/resolvers.js
const resolvers = {
  Query: {
    hello: () => 'Hello from GraphQL!',
  },
};

module.exports = resolvers;
EOF

cat << EOF > backend/graphql-server/Dockerfile
FROM node:14

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 4000

CMD [ "npm", "start" ]
EOF

cat << EOF > backend/lambda-functions/graphqlHandler.js
const { ApolloServer } = require('apollo-server-lambda');
const typeDefs = require('../graphql-server/src/schema');
const resolvers = require('../graphql-server/src/resolvers');

const server = new ApolloServer({
  typeDefs,
  resolvers,
});

exports.handler = server.createHandler();
EOF

# Update package.json files
npm set-script --prefix frontend/react-app start "react-scripts start"
npm set-script --prefix frontend/react-app build "react-scripts build"
npm set-script --prefix frontend/react-app test "react-scripts test"
npm set-script --prefix frontend/react-app eject "react-scripts eject"

npm set-script --prefix backend/graphql-server start "node index.js"

npm set-script deploy "serverless deploy"

# Commit the changes
git add .
git commit -m "Add sample code to project structure"
