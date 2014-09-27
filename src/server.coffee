express = require 'express'
server  = express()

server.get('/', (req, res) -> res.send('hello') )


module.exports = server

