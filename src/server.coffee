express              = require 'express'
server               = express()
SearchDataController = require('./SearchDataController')

server.searchDataController = new SearchDataController()
server.set('view engine', 'jade')
server.get('/', (req, res) -> res.render('index'))


server.searchDataController.mapRoutes(server)

module.exports = server

