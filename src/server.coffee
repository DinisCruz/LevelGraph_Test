express              = require 'express'
server               = express()
SearchDataController = require('./SearchDataController')

server.searchDataController = new SearchDataController()
server.set('view engine', 'jade')
server.get('/', (req, res) -> res.render('index'))
server.use('/vis', express.static(process.cwd() + '/node_modules/vis/dist'))
server.get('/__dirname',(req,res) -> res.send(__dirname));
server.searchDataController.mapRoutes(server)

module.exports = server

