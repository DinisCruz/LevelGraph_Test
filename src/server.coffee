express              = require 'express'
server               = express()
SearchDataController = require('./SearchDataController')

server.searchDataController = new SearchDataController()
server.set('view engine', 'jade')
server.get('/', (req, res) -> res.render('index'))
server.use('/vis', express.static(process.cwd() + '/node_modules/vis/dist'))
server.use('/lib', express.static(process.cwd() + '/views/lib'))
server.searchDataController.mapRoutes(server)

module.exports = server

