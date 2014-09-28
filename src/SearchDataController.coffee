ArticlesGraph = require('./ArticlesGraph')

class SearchDataController
    constructor: ->
                    @articlesGraph = new ArticlesGraph()
    
    getDataFilePath:
        (req,res)=>
            res.send(@articlesGraph.dataFilePath())
            
    getData: (req,res)=>
        @articlesGraph.openDb()
        @articlesGraph.loadTestData () =>
            @articlesGraph.allData (error, data) =>
                @articlesGraph.closeDb =>
                    res.type('application/json')
                        .send(data)
                    
    getSearchGraph: (req,res)=>
        viewName = "Data Validation"
        @articlesGraph.openDb()
        @articlesGraph.loadTestData () =>
            @articlesGraph.searchGraph viewName, (error, data) =>
                @articlesGraph.closeDb =>
                    res.type('application/json')
                        .send(data)
        
    mapRoutes: (server)->
        server.get('/dataFilePath'    , @getDataFilePath)
        server.get('/data.json'       , @getData)
        server.get('/searchGraph.json', @getSearchGraph)
        
        #server.get('/123', (req, res) -> res.send('this is a LevelGraph PoC app') )
        
        
module.exports = SearchDataController