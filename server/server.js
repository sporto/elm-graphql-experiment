var express = require("express")
var schema = require('./schema')

var gql = require('graphql')
var bodyParser = require('body-parser')
var cors = require('cors')
var app  = express();
var PORT = 3000;

app.use(cors())

// parse POST body as text
app.use(bodyParser.text({ type: 'application/graphql' }));

app.post('/graphql', (req, res) => {
	// execute GraphQL!
	gql.graphql(schema, req.body)
		.then(function(result) {
			res.send(JSON.stringify(result, null, 2));
		});
});

var server = app.listen(PORT, function () {
	let host = server.address().address;
	let port = server.address().port;

	console.log('GraphQL listening at http://%s:%s', host, port);
});