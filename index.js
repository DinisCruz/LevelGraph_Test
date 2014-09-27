require('coffee-script/register');              // adding coffee-script support

var server = require('./src/server');           // gets the express server

server.port  = process.env.PORT || 1331;        // sets port
server.listen(server.port);                     // start server

console.log('Server started at: http://localhost:' + server.port)