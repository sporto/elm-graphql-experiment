var gql = require('graphql')

let count = 0;

let schema = new gql.GraphQLSchema({
  query: new gql.GraphQLObjectType({
    name: 'RootQueryType',
    fields: {
      count: {
        type: gql.GraphQLInt,
        resolve: function() {
          return count;
        }
      }
    }
  })
});

module.exports = schema;