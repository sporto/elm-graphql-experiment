Test with 

curl -XPOST -H "Content-Type:application/graphql"  -d 'query RootQueryType { client(id: 1) { name }  }' http://localhost:3000/graphql