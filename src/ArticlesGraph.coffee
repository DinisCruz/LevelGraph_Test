require('fluentnode')
fs         = require('fs')
levelup    = require("level"        )
leveldown  = require('leveldown'    )
levelgraph = require('levelgraph'   )

class ArticlesGraph
    constructor: ->
                    #console.log('in ArticlesGraph ctor')
                    @dbPath     = './db'
                    #@level      = levelup   (@dbPath)
                    #@db         = levelgraph(@level)
                    @level      = null
                    @db         = null
                    @dataFile   = './src/article-data.json'
                    @data       = null
    
    #Setup methods
    
    closeDb: (done)->
                @level.close =>
                    @db.close =>
                        done()
                
    openDb : ->
                @level      = levelup   (@dbPath)
                @db         = levelgraph(@level)
            
    dataFilePath: -> process.cwd().path.join(@dataFile)
    dataFromFile: ()-> JSON.parse fs.readFileSync(@dataFilePath(), "utf8")
    
    loadTestData: (callback) =>
        @data = @dataFromFile()             
        @db.put @data, callback
    
    # Search methods
    
    allData: (callback)->
        @db.search [{
                        subject: @db.v("subject"),
                        predicate: @db.v("predicate"),
                        object: @db.v("object"),
                    }], callback
     
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
        @db.search [{   subject  : @db.v("viewId"   ),  predicate: "Title",  object   : viewName }
                    {   subject  : @db.v("viewId"   ),  predicate: "View" ,  object   : @db.v("childViewId") }
                    {   subject  : @db.v("articleId"),  predicate: "View" ,  object   : @db.v("childViewId") }
                    {   subject  : @db.v("articleId"),  predicate: "is an" ,  object   : @db.v("Article") }
                    {   subject  : @db.v("articleId"),  predicate: @db.v("predicate") ,  object   : @db.v("object") }
                    ],
                    materialized: {
                                        viewName    : viewName
                                        subject     : @db.v("viewId")
                                        childViewId : @db.v("childViewId")
                                        articleId   : @db.v("articleId")
                                        predicate   : @db.v("predicate")
                                        object      : @db.v("object")
                                        #object      : @db.v("object")
                                  }
                    callback

    createSearchData: (viewName,callback)->
        mapGraphData = (err,data) ->
            callback(data)
        @searchGraph(viewName, mapGraphData)
        
module.exports = ArticlesGraph
