import React from 'react';
import { ApolloClient, InMemoryCache, ApolloProvider, useQuery, gql } from '@apollo/client';

const client = new ApolloClient({
  uri: process.env.REACT_APP_GRAPHQL_ENDPOINT || 'http://localhost:4000/graphql',
  cache: new InMemoryCache()
});

const GET_HELLO = gql`
  query {
    hello
  }
`;

function HelloWorld() {
  const { loading, error, data } = useQuery(GET_HELLO);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error :( {error.message}</p>;

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
