require('fluentnode')
fs          = require('fs')
levelup     = require("level"        )
leveldown   = require('leveldown'    )
levelgraph  = require('levelgraph'   )
articleData = require('./articleData.coffee')

class ArticlesGraph
    constructor: ->
                    @dbPath     = './db'
                    @level      = null
                    @db         = null
                    @dataFile   = './src/article-data.json'
                    @data       = null
    
    #Setup methods
    
    closeDb: (callback)->
                if(@level == null)                    
                    callback()
                else                
                    @level.close =>
                        @db.close =>
                            @db    = null
                            @level = null
                            callback()
                
    openDb : ->
                @level      = levelup   (@dbPath)
                @db         = levelgraph(@level)
                
    deleteDb: (callback)=>
        console.log 'Deleting the articleDB'
        require('child_process').spawn('rm', ['-Rv',@dbPath])
                                .on 'exit', callback

            
    dataFilePath: -> process.cwd().path.join(@dataFile)
    dataFromFile: ()-> JSON.parse fs.readFileSync(@dataFilePath(), "utf8")
    
    loadTestData: (callback) =>
        if (@db==null)
            @openDb()
        @data = @dataFromFile()
        articleData @db, =>
            @db.put @data, callback
    
    # Search methods
    
    allData: (callback)->
        @db.search [{
                        subject  : @db.v("subject"),
                        predicate: @db.v("predicate"),
                        object   : @db.v("object"),
                    }], callback
     
    query: (key, value, callback)=>
        switch key
            when "subject"      then @db.get     { subject: value}, callback
            when "predicate"    then @db.get     { predicate: value}, callback
            when "object"       then @db.get     { object: value}, callback
            when "all"          then @allData callback
            else callback(null,[])
                    
        
        
    articlesInView_by_Id: (viewId, callback) ->
        #console.log("\n >  getting all viewArticles from #{viewId}")
        @db.get object: viewId, callback
        
    articlesInView_by_Name: (viewName, callback) ->
        #console.log("\n > getting all viewArticles from #{viewName}")
        @db.search [{
                        subject  : @db.v("x"),
                        predicate: "Title",
                        object   : viewName
                    },
                    {
                        subject  : @db.v("y"),
                        predicate: "View",
                        object   : @db.v("x")
                    },
                    {
                        subject  : @db.v("y"),
                        predicate: "is an",
                        object   : "Article"
                    },
                    {
                        subject   : @db.v("y"),
                        predicate : @db.v("predicate"),
                        object    : @db.v("object"),
                    },
                    ],
                        materialized: {
                                            #view_Name: viewName
                                            view_id  : @db.v('x')
                                            action   : "contains",
                                            subject  : @db.v("y")
                                            predicate: @db.v("predicate")
                                            object   : @db.v("object")
                                      },callback
    
    searchGraph : (viewName,callback)->
        @db.search [{   subject  : @db.v("id"       ),  predicate: "Title"    ,  object   : viewName                }  # find item with Title 
                    {   subject  : @db.v("id"       ),  predicate: "is an"    ,  object   : @db.v("Folder")         }  #""
                    {   subject  : @db.v("viewId"   ),  predicate: "Contains" ,  object   : @db.v("childViewId")    }
                    {   subject  : @db.v("articleId"),  predicate: "View"     ,  object   : @db.v("childViewId")    }
                    {   subject  : @db.v("articleId"),  predicate: "is an"    ,  object   : @db.v("Article")        }
                    {   subject  : @db.v("articleId"),  predicate: @db.v("predicate") ,  object   : @db.v("object") }
                    ],
                    materialized: {
                                        viewName    : viewName
                                        subject     : @db.v("viewId")
                                        childViewId : @db.v("childViewId")
                                        articleId   : @db.v("articleId")
                                        predicate   : @db.v("predicate")
                                        object      : @db.v("object")                                        
                                  }
                    callback

    createSearchData: (folderName,callback)->        
        
        searchData              = {}
        
        setDefaultValues = ->
            searchData.title        = folderName
            searchData.containers   = []
            searchData.resultsTitle = "n/n results showing"
            searchData.results      = []
            searchData.filters      = []
        
        metadata = {}
        
        mapMetadata = ()=>
            for item of metadata when typeof(metadata[item]) != 'function'
                filter = {}
                filter.title   = item
                filter.results = []
                for mapping of metadata[item]
                    if typeof(metadata[item][mapping]) != 'function'
                        result = { title : mapping , size: metadata[item][mapping]}
                        filter.results.push(result)                        
                searchData.filters.push(filter)
            callback(searchData)
            
        mapArticles = (articles) =>            
            if (articles.empty())                
                mapMetadata()
            else
                article = articles.pop()
                @query 'subject', article, (err,data) ->
                    result = { title: null, link: null , id: null, summary: null, score : null }
                    for item in data
                        switch item.predicate
                            when 'Guid'     then result.id = item.object
                            when 'Title'    then result.title = item.object
                            when 'Summary'  then result.summary = item.object
                            when 'is an'    then #do Nothing
                            when 'View'     then #do Nothing
                            else 
                                if not metadata[item.predicate] then metadata[item.predicate] = {}
                                if metadata[item.predicate][item.object] 
                                    metadata[item.predicate][item.object]++
                                else
                                    metadata[item.predicate][item.object] = 1
                    result.link = 'https://tmdev01-sme.teammentor.net/'+result.id
                    result.score = 0                    
                    searchData.results.push(result)
                    mapArticles(articles)
        
        mapViews = (viewsToMap,articles) =>                
            if (viewsToMap.empty())
                mapArticles(articles)
            else
                viewToMap = viewsToMap.pop()                
                @query 'subject', viewToMap.id, (err,data) ->
                    container = { title: null, id: null, size : viewToMap.size }
                    for item in data
                        switch item.predicate
                            when 'Guid'  then container.id = item.object
                            when 'Title' then container.title = item.object                            
                    searchData.containers.push(container)    
                    mapViews(viewsToMap,articles)
            
        mapResults = (err,data) =>            
            viewsCount = {}
            articles   = []
            for item in data                
                articles.push(item.article)
                if viewsCount[item.view] then viewsCount[item.view]++ else viewsCount[item.view] = 1
                
            searchData.resultsTitle = "#{articles.length}/#{data.length} results showing"
            
            viewsToMap = ({ id: key, size: viewsCount[key]} for key of viewsCount when typeof(viewsCount[key]) != 'function')
            
            mapViews(viewsToMap, articles)
            
        setDefaultValues()        
        @db.nav("Data Validation").archIn('Title'    ).as('folder')
                                  .archOut('Contains').as('view')
                                  .archIn('View'     ).as('article')
                                  .solutions(mapResults)        
    
    getRawGraphData: (queryKey, queryValue,callback)=>       
        if not queryKey
            queryKey = "all"
        if not queryValue
            queryValue = ""   
        @query queryKey, queryValue, (err, data) =>
            DataSet   = require('vis/lib/DataSet')          
            nodes     = []
            edges     = []
            for item in data
                if item.subject not in nodes
                    nodes.push(item.subject)
                if item.object not in nodes
                    nodes.push(item.object)
                edges.push { from: item.subject , to: item.object, label:item.predicate}
                
            graphData = { nodes: nodes, edges: edges }  
            callback(graphData)
            
    getGraphData: (callback) =>        
        @query "all", null, (err, data) =>
            DataSet   = require('vis/lib/DataSet')
            nodesAdded   = []
            nodesMapping = {}
            nodes        = []
            edges        = []
            
            setNodeStyle = (node)->                
                node.mass = 7               
                node.shape = 'box'
                node.color = {}                                        

                        
            setEdgeStyle = (edge)->
                fromNode = nodesMapping[edge.from]
                toNode = nodesMapping[edge.to]
                #if(edge.to.length < 30) 
                #    fromNode.title += '\n - ' + edge.to
                switch(edge.label)
                    when 'is'                                             
                        switch (edge.to)
                            when 'Search'
                                fromNode.color.background =  "#c3c335"                        
                            when 'Articles','Queries', 'Metadatas'
                                fromNode.color.background = "#92a792"                            
                            when 'Query'     then fromNode.color.background = "#e6b1b1"                        
                            when 'Article'   then fromNode.color.background = "#97d997"
                            when 'Metadata'  then fromNode.color.background = "#95bff7"
                            when 'XRef'
                                fromNode.color.background = '#000000'
                                fromNode.shape           = 'dot'
                                fromNode.radiusMax       = '10'
                                #fromNode.fontColor        = '#ffffff'                                                                
                            else
                                fromNode.color.background =  "#FFc335"                    
                        fromNode.fontSize  = 30
                        toNode.visible     = false
                    
                    when 'title'
                        fromNode.label  = edge.to #+ ":\n\n" + fromNode.label
                        toNode.visible = false
                        
                    when 'guid','weight', 'summary'
                        toNode.visible = false
                    
                edge.style = 'arrow'    
                edge.fontSize = 10                
                edge.length  = 150
                switch (edge.label)
                    when 'target'                         
                        xrefTarget = nodesMapping[toNode.id]
                        fromNode.label = xrefTarget.label
                        fromNode.title += '<br/>....ArticleId: ' + toNode.id
                        fromNode.fontSize  = 20
                        return false
                    when 'weight'
                        fromNode.value = toNode.label
                        fromNode.title += '<br/>....Weight: ' + toNode.label
                        return true
                
                return true

            
            addNode = (nodeId)->
                #if (not nodeId or nodeId.length >30 or nodeId.length < 4) 
                #    return                                                
                if nodeId not in nodesAdded
                    nodesAdded.push(nodeId)
                    node = {
                                id       : nodeId
                                label    : nodeId
                                title    : nodeId    
                                visible  : true
                            }
                    setNodeStyle(node)           
                    nodes.push(node)
                    nodesMapping[nodeId] = node
            
            addEdge = (item)->   
                edge = { 
                            from      : item.subject
                            to        : item.object 
                            label     : item.predicate                            
                       }
                        
                if setEdgeStyle(edge)            
                    edges.push(edge)
            
            for item in data#.splice(0,40)                
                addNode(item.subject)
                addNode(item.object)
                addEdge(item)
                
            nodes = (node for node in nodes when node.visible)
            
            graphData = { nodes: nodes, edges: edges }  
            graphData.refresh = false
            callback(graphData)
        
module.exports = ArticlesGraph
