var g = require('graphql')

var ClientType = new g.GraphQLObjectType({
  name: 'Client',
  fields: {
	id: { type: g.GraphQLInt },
	name: { type: g.GraphQLString },
  }
});

var clients = {
	1:  {
		id: 1,
		name: "Name"
	}
}

var schema = new g.GraphQLSchema({
  query: new g.GraphQLObjectType({
	name: 'RootQueryType',
	fields: {
	  client: {
		type: ClientType,
		args: {
			id: { type: g.GraphQLInt }
		},
		resolve: function(_, args) {
			return clients[args.id];
		}
	  }
	}
  })
});

module.exports = schema;