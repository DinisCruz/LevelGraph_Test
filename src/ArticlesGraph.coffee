levelup    = require("level"        )
leveldown  = require('leveldown'    )
levelgraph = require('levelgraph'   )    

class ArticlesGraph
    constructor: ->
                    @dbPath = "./articlesGraphDB"
                    @level  = levelup   (@dbPath)
                    @db     = levelgraph(@level)
    
    loadTestData: (callback) ->
        @data = [
                #Article: All Input Is Validated - HTML5 - Implementation
                { subject: "e7ed2762fc3e"   , predicate: "Guid"      , object: "a330bfdd-9576-40ea-997e-e7ed2762fc3e"   }
                { subject: "e7ed2762fc3e"   , predicate: "is an"     , object: "Article"                                }
                { subject: "e7ed2762fc3e"   , predicate: "Title"     , object: "All Input Is Validated"                 }
                { subject: "e7ed2762fc3e"   , predicate: "Technology", object: "HTML5"                                  }
                { subject: "e7ed2762fc3e"   , predicate: "Phase"     , object: "Implementation"                         }
                { subject: "e7ed2762fc3e"   , predicate: "Type"      , object: "Checklist Item"                         }
                { subject: "e7ed2762fc3e"   , predicate: "Category"  , object: "Input and Data Validation"              }
                { subject: "e7ed2762fc3e"   , predicate: "View"      , object: "bcea0b7ace25"                           } # View: Validate All Input
                
                #Article: All Input Is Validated - Android - Implementation
                { subject: "d5bc580df781"   , predicate: "Guid"      , object: "cde61562-aff2-40a0-beb9-d5bc580df781"   }
                { subject: "d5bc580df781"   , predicate: "is an"     , object: "Article"                                }
                { subject: "d5bc580df781"   , predicate: "Title"     , object: "All Input Is Validated"                 }
                { subject: "d5bc580df781"   , predicate: "Technology", object: "Andoid"                                 }
                { subject: "d5bc580df781"   , predicate: "Phase"     , object: "Implementation"                         }
                { subject: "d5bc580df781"   , predicate: "Type"      , object: "Checklist Item"                         }
                { subject: "d5bc580df781"   , predicate: "Category"  , object: "Input and Data Validation"              }
                { subject: "d5bc580df781"   , predicate: "View"      , object: "bcea0b7ace25"                           } # View: Validate All Input
                  
                #Article: All Input Is Validated - iOS - Implementation
                { subject: "9771b8ed3eda"   , predicate: "Guid"      , object: "ed7404ea-00fa-4f4c-a692-9771b8ed3eda"   }
                { subject: "9771b8ed3eda"   , predicate: "is an"     , object: "Article"                                }
                { subject: "9771b8ed3eda"   , predicate: "Title"     , object: "All Input Is Validated"                 }
                { subject: "9771b8ed3eda"   , predicate: "Technology", object: "iOS"                                    }
                { subject: "9771b8ed3eda"   , predicate: "Phase"     , object: "Implementation"                         }
                { subject: "9771b8ed3eda"   , predicate: "Type"      , object: "Checklist Item"                         }
                { subject: "9771b8ed3eda"   , predicate: "Category"  , object: "Input and Data Validation"              }
                { subject: "9771b8ed3eda"   , predicate: "View"      , object: "bcea0b7ace25"                           } # View: Validate All Input
                  
                #Article: All Input Is Validated - C++ - Design
                { subject: "1106d793193b"   , predicate: "Guid"      , object: "0f3bb6f1-9058-463f-a835-1106d793193b"   }
                { subject: "1106d793193b"   , predicate: "is an"     , object: "Article"                                }
                { subject: "1106d793193b"   , predicate: "Title"     , object: "All Input Is Validated"                 }
                { subject: "1106d793193b"   , predicate: "Technology", object: "C++"                                    }
                { subject: "1106d793193b"   , predicate: "Phase"     , object: "Design"                                 }
                { subject: "1106d793193b"   , predicate: "Type"      , object: "Checklist Item"                         }
                { subject: "1106d793193b"   , predicate: "Category"  , object: "Input and Data Validation"              }
                { subject: "1106d793193b"   , predicate: "View"      , object: "bcea0b7ace25"                           } # View: Validate All Input
                  
                #Article: Centralize Input Validation - Web Application
                { subject: "3e15eef3a23c"   , predicate: "Guid"      , object: "172019bd-2e47-49a0-8852-3e15eef3a23c"   }
                { subject: "3e15eef3a23c"   , predicate: "Title"     , object: "Centralize Input Validation"            }
                { subject: "3e15eef3a23c"   , predicate: "Technology", object: "Web Application"                        }
                { subject: "3e15eef3a23c"   , predicate: "Phase"     , object: "Implementation"                         }
                { subject: "3e15eef3a23c"   , predicate: "Type"      , object: "Guideline"                              }
                { subject: "3e15eef3a23c"   , predicate: "Category"  , object: "Input and Data Validation"              }
                { subject: "3e15eef3a23c"   , predicate: "View"      , object: "e6e84097e9e0"                           } # View: Perform Validation on the Server
                  
                #Article: Client-side Validation Is Not Relied On - ASP.NET 4.0
                { subject: "9f8b44a5b27d"   , predicate: "Guid"      , object: "9607b6e3-de61-4ff7-8ef0-9f8b44a5b27d"   }
                { subject: "9f8b44a5b27d"   , predicate: "Title"     , object: "Client-side Validation Is Not Relied On"}
                { subject: "9f8b44a5b27d"   , predicate: "Technology", object: "ASP.NET 4.0"                            }
                { subject: "9f8b44a5b27d"   , predicate: "Phase"     , object: "Implementation"                         }
                { subject: "9f8b44a5b27d"   , predicate: "Type"      , object: "Checklist Item"                         }
                { subject: "9f8b44a5b27d"   , predicate: "Category"  , object: "Input and Data Validation"              }
                { subject: "9f8b44a5b27d"   , predicate: "View"      , object: "e6e84097e9e0"                           } # View: Perform Validation on the Server
                
                #Article: Client-side Validation Is Not Relied On - ASP.NET 4.0
                { subject: "46d6939abe45"   , predicate: "Guid"      , object: "585828bc-06d7-4f7d-94fc-46d6939abe45"   }
                { subject: "46d6939abe45"   , predicate: "Title"     , object: "Client-side Validation Is Not Relied On"}
                { subject: "46d6939abe45"   , predicate: "Technology", object: "ASP.NET 3.5"                            }
                { subject: "46d6939abe45"   , predicate: "Phase"     , object: "Design "                                }
                { subject: "46d6939abe45"   , predicate: "Type"      , object: "Checklist Item"                         }
                { subject: "46d6939abe45"   , predicate: "Category"  , object: "Input and Data Validation"              }
                { subject: "46d6939abe45"   , predicate: "View"      , object: "e6e84097e9e0"                           } # Perform Validation on the Server
                
                
                #View: Validate All Input
                { subject: "bcea0b7ace25"   , predicate: "Guid"      , object: "1f7e5386-bb3c-4060-8364-bcea0b7ace25"   }
                { subject: "bcea0b7ace25"   , predicate: "is an"     , object: "View"                                   }
                { subject: "bcea0b7ace25"   , predicate: "Title"     , object: "Validate All Input"                     }
                  
                #View: Perform Validation on the Server
                { subject: "e6e84097e9e0"   , predicate: "Guid"      , object: "4eef2c5f-7108-4ad2-a6b9-e6e84097e9e0"   }
                { subject: "e6e84097e9e0"   , predicate: "is an"     , object: "View"                                   }
                { subject: "e6e84097e9e0"   , predicate: "Title"     , object: "Perform Validation on the Server"       }
  
  
                #Folder: Data Validation
                { subject: "d994753ff409"   , predicate: "Guid"      , object: "24b76e10-6caf-4f83-8c6c-d994753ff409"   }
                { subject: "d994753ff409"   , predicate: "is an"     , object: "View"                                   }
                { subject: "d994753ff409"   , predicate: "Title"     , object: "Data Validation"                        }
                { subject: "d994753ff409"   , predicate: "View"      , object: "bcea0b7ace25"                           } # View: Validate All Input
                { subject: "d994753ff409"   , predicate: "View"      , object: "e6e84097e9e0"                           } # View: Perform Validation on the Server
                  
                #Library: Uno
                { subject: "6234f2d47eb7"   , predicate: "Guid"      , object: "be5273b1-d682-4361-99d9-6234f2d47eb7"   }
                { subject: "6234f2d47eb7"   , predicate: "is an"     , object: "View"                                   }
                { subject: "6234f2d47eb7"   , predicate: "Title"     , object: "Uno"                                    }
                { subject: "6234f2d47eb7"   , predicate: "View"      , object: "d994753ff409"                           } # View: Data Validation
               ]
        
        @db.put(@data, callback)
        #callback()
    
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
                     
    createSearchData: (viewName,callback)->
             
        that = this
        mapGraphData = (err,data) ->
        
            callback(data)
            
        searchGraph = () =>
            this.db.search [{   subject  : @db.v("viewId"   ),  predicate: "Title",  object   : viewName }
                            {   subject  : @db.v("viewId"   ),  predicate: "View" ,  object   : @db.v("childViewId") }
                            {   subject  : @db.v("articleId"),  predicate: "View" ,  object   : @db.v("childViewId") }
                            #{   subject  : @db.v("articleId"),  predicate: "is an" ,  object   : @db.v("Article") }
                            {   subject  : @db.v("articleId"),  predicate: @db.v("predicate") ,  object   : @db.v("object") }
                            ],
                            materialized: {
                                                viewName    : viewName
                                                subject     : @db.v("viewId")
                                                childViewId : @db.v("childViewId")
                                                articleId   : @db.v("articleId")
                                                predicate: @db.v("predicate")
                                                object   : @db.v("object")
                                                #object      : @db.v("object")
                                          },callback
                            mapGraphData
        
        searchGraph()
        
module.exports = ArticlesGraph
