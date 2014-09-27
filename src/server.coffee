express = require 'express'
server  = express()

server.get('/', (req, res) -> res.send('this is a LevelGraph PoC app') )


module.exports = server

