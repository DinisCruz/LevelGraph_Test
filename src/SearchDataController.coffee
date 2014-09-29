ArticlesGraph = require('./ArticlesGraph')

class SearchDataController
    constructor: ->
                    @articlesGraph = new ArticlesGraph()
    
    executeOnArticlesGraph: (methodToInvoke, params, callback) =>
        @articlesGraph.openDb()
        @articlesGraph.loadTestData () =>
            @articlesGraph[methodToInvoke] (error, data) =>
                    throw error if error
                    callback(error, data)
                
        
    sendDataAsJson: (res, data)=>
        @articlesGraph.closeDb =>
            json = JSON.stringify(data,null, '    ')
            res.type('application/json')
                .send(json)
    
    getDataFilePath:
        (req,res)=>
            res.send(@articlesGraph.dataFilePath())
            
    getData: (req,res)=>
        @articlesGraph.loadTestData () =>
            @articlesGraph.allData (error, data)=>
                @sendDataAsJson(res, data)
            
    getSearchGraph: (req,res)=>
        viewName = "Data Validation"
        @articlesGraph.loadTestData () =>
            @articlesGraph.searchGraph viewName, (error, data) =>
                @sendDataAsJson(res, data)
                
    query: (req,res) =>
        key   = req.params.key #'object'
        value =  req.params.value #'Design'
        @articlesGraph.loadTestData () =>
            @articlesGraph.query key, value, (error, data) =>
                @sendDataAsJson(res, data)
        
        
    mapRoutes: (server)->
        server.get('/dataFilePath'     , @getDataFilePath)
        server.get('/data.json'        , @getData)
        server.get('/searchGraph.json' , @getSearchGraph)
        server.get('/query/:key/:value', @query)
        
        #server.get('/123', (req, res) -> res.send('this is a LevelGraph PoC app') )
        
        
module.exports = SearchDataController