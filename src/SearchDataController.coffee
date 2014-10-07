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
                
        
    sendAsJson: (res, data)=>
        @articlesGraph.closeDb =>
            json = JSON.stringify(data,null, '    ')
            res.header('Access-Control-Allow-Origin', '*')
            res.type  ('application/json')
                .send(json)
                
    sendAsJade: (res, jadePage, data) => 
        @articlesGraph.closeDb =>
            res.render(jadePage, data)
    
    getDataFilePath:
        (req,res)=>
            res.send(@articlesGraph.dataFilePath())
    
    getGraphData: (req,res)=>        
        @articlesGraph.loadTestData () =>    
            @articlesGraph.getGraphData (graphData)=>
                @sendAsJson(res, graphData)
    
    getGraphDataView: (req,res)=>   
        @articlesGraph.loadTestData () =>    
            @articlesGraph.getGraphData (graphData)=>
                 @sendAsJade(res, "rawGraphData", {data :graphData })

    getRawGraphData: (req,res)=>  
        @articlesGraph.loadTestData () =>    
            key   = req.params.key     
            value =  req.params.value  
            @articlesGraph.getRawGraphData key, value, (graphData)=>
                @sendAsJson(res, graphData)
    
    getData: (req,res)=>
        @articlesGraph.loadTestData () =>
            @articlesGraph.allData (error, data)=>
                @sendAsJson(res, data)
            
 #  getSearchGraph: (req,res)=>
 #      viewName = "Data Validation"
 #      @articlesGraph.loadTestData () =>
 #          @articlesGraph.searchGraph viewName, (error, data) =>
 #              @sendAsJson(res, data)
                
    getSearchData: (req,res)=>
        viewName = "Data Validation"
        @articlesGraph.loadTestData () =>
            @articlesGraph.createSearchData viewName, (data) =>                
                @sendAsJson(res, data)            
    
    
    query: (req,res) =>
        key   = req.params.key      #'object'
        value =  req.params.value   #'Design'
        @articlesGraph.loadTestData () =>
            @articlesGraph.query key, value, (error, data) =>
                @sendAsJson(res, data)
                
     view: (req,res) =>
        key   = req.params.key      #'object'
        value =  req.params.value   #'Design'
        @articlesGraph.loadTestData () =>
            @articlesGraph.query key, value, (error, data) =>
                @sendAsJade(res, "view", {data : data })
    
    mapRoutes: (server)->
        server.get('/dataFilePath'     , @getDataFilePath)
        server.get('/data.json'        , @getData)
        server.get('/searchData.json'  , @getSearchData)
        #server.get('/searchGraph.json' , @getSearchGraph)
        server.get('/query/:key/'      , @query)
        server.get('/query/:key/:value', @query)        
        server.get('/view/:key/'       , @view)
        server.get('/view/:key/:value' , @view)
        server.get('/graphData.json'           , @getGraphData)
        server.get('/graphData'                , @getGraphDataView)
        server.get('/rawGraphData/:key/:value' , @getRawGraphData)
        server.get('/rawGraphData.json'        , @getRawGraphData)        
        
module.exports = SearchDataController