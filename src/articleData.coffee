uniqueId = () ->Math.floor(Math.random() * 0x10000).toString(16)
  
addMapping = (data, subject, predicate, object)->
    data.push({ subject:subject , predicate:predicate  , object:object })

addMappings = (data, subject, mappings)->        
    if typeof(mappings.length) != 'undefined'   # is an array
        for mapping in mappings
            for key, value of mapping                
                data.push({ subject:subject , predicate:key  , object:value})    
    else        
        for key, value of mappings            
            if (typeof(value) == 'string')
                data.push({ subject:subject , predicate:key  , object:value})    
            else
                for item in value
                    data.push({ subject:subject , predicate:key  , object:item})                


addData = (db, callback)->    
    data = [] #[{ subject: "e7ed2762fc3e"   , predicate: "Title"   , object: "All Input Is Validated"     }
              #{ subject: "e7ed2762fc3e"   , predicate: "abcaa"   , object: "test"                       }]
            
    #addMapping(data, uniqueId(), "is an", "Query")
            
    addMappings data, "keyword_00000762fc3e",  [ { title     : "Data Validation"                  },
                                                 { is        : "Search"                           },
                                                 { contains  : "queries-00002762fc3e"             },
                                                 { contains  : "articles-00002762fc3e"            },
                                                 { contains  : "metadatas-00002762fc3e"           }]
                                                 
    addMappings data, "queries-00002762fc3e",  [ { title     : "Queries"                          },
                                                 { is        : "Queries"                          },
                                                 { contains  : "query-10002762fc3e"               },
                                                 { contains  : "query-20002762fc3e"               },
                                                 { contains  : "query-30002762fc3e"               }]
                                                 
    addMappings data, "articles-00002762fc3e",   { is: "Articles" , title: "Articles"  , contains  : ['article-d5bc580df781' 
                                                                                                      'article-e7ed2762fc3e'
                                                                                                      'article-9771b8ed3eda'
                                                                                                      'article-1106d793193b'
                                                                                                      'article-3e15eef3a23c'
                                                                                                      'article-9f8b44a5b27d'
                                                                                                      'article-46d6939abe45']}
    
                                                 
    # Query    
    addMappings data, "query-10002762fc3e"  ,  { is: "Query",   title: "Perform Validation on the Server", xref: ['xref-31002762fc3e'
                                                                                                                  'xref-32002762fc3e'
                                                                                                                  'xref-33002762fc3e'
                                                                                                                  'xref-34002762fc3e'
                                                                                                                  'xref-35002762fc3e'
                                                                                                                  'xref-36002762fc3e'
                                                                                                                  'xref-37002762fc3e']}
    addMappings data, "query-20002762fc3e"  ,  { is: "Query",   title: "Validate All Input"              , xref: ['xref-38002762fc3e'
                                                                                                                  'xref-39002762fc3e'
                                                                                                                  'xref-41002762fc3e']}

    addMappings data, "query-30002762fc3e"  ,  { is: "Query",   title: "Use White-list Validation"       , xref: ['xref-42002762fc3e'
                                                                                                                  'xref-43002762fc3e'
                                                                                                                  'xref-44002762fc3e'
                                                                                                                  'xref-45002762fc3e']}
    
    
    
    # Articles
    addMappings data, "article-e7ed2762fc3e",  { is: 'Article', title : 'All Input Is Validated'                    ,  guid: 'a330bfdd-9576-40ea-997e-e7ed2762fc3e'}
    addMappings data, "article-d5bc580df781",  { is: 'Article', title : 'All Input Is Validated'                    ,  guid: 'cde61562-aff2-40a0-beb9-d5bc580df781'}
    addMappings data, "article-9771b8ed3eda",  { is: 'Article', title : 'All Input Is Validated'                    ,  guid: 'ed7404ea-00fa-4f4c-a692-9771b8ed3eda'}
    addMappings data, "article-1106d793193b",  { is: 'Article', title : 'All Input Is Validated'                    ,  guid: '0f3bb6f1-9058-463f-a835-1106d793193b'}
    addMappings data, "article-3e15eef3a23c",  { is: 'Article', title : 'Centralize Input Validation'               ,  guid: '172019bd-2e47-49a0-8852-3e15eef3a23c' , summary: 'All web applications need to validate their input, and this should be performed in a single centralized place, to ensure consistency.'}
    addMappings data, "article-9f8b44a5b27d",  { is: 'Article', title : 'Client-side Validation Is Not Relied On'   ,  guid: '9607b6e3-de61-4ff7-8ef0-9f8b44a5b27d' , summary: 'Verify that the same or more rigorous checks are performed on the server as on the client. Verify that client-side validation is used only for usability and to reduce the number of posts to the server.'}
    addMappings data, "article-46d6939abe45",  { is: 'Article', title : 'Client-side Validation Is Not Relied On'   ,  guid: '585828bc-06d7-4f7d-94fc-46d6939abe45' , summary: 'Verify that the same or more rigorous checks are performed on the server as on the client. Verify that client-side validation is used only for usability and to reduce the number of posts to the server.'}
    
    
    # Metadata
    addMappings data, "metadatas-00002762fc3e", { is: 'Metadatas', title: 'Metadatas'                  , contains: ['query-00102762fc3e' 
                                                                                                                    'query-00202762fc3e'  
                                                                                                                    'query-00302762fc3e'
                                                                                                                    'query-00402762fc3e'    ]}
                                                                                                                    
                                                                                                                    
    # Technology (Metadata)
    addMappings data, "query-00102762fc3e"    , { is: 'Query'    , title: 'Technology'                 , contains: ['metadata-00002762fc3e' 
                                                                                                                    'metadata-10002762fc3e'  
                                                                                                                    'metadata-20002762fc3e'
                                                                                                                    'metadata-30002762fc3e'
                                                                                                                    'metadata-70002762fc3e'
                                                                                                                    'metadata-11002762fc3e'
                                                                                                                    'metadata-13002762fc3e']}
                                                                                                                    
    addMappings data, "metadata-00002762fc3e" , { is: 'Metadata' , title : 'C++'                       , xref    : ['xref-13002762fc3e']}
    addMappings data, "metadata-10002762fc3e" , { is: 'Metadata' , title : 'ASP.NET 4.0'               , xref    : ['xref-22002762fc3e']}
    addMappings data, "metadata-13002762fc3e" , { is: 'Metadata' , title : 'ASP.NET 3.5'               , xref    : ['xref-26002762fc3e']}
    addMappings data, "metadata-20002762fc3e" , { is: 'Metadata' , title : 'Andoid'                    , xref    : ['xref-40002762fc3e']}
    addMappings data, "metadata-30002762fc3e" , { is: 'Metadata' , title : 'HTML5'                     , xref    : ['xref-00002762fc3e']}
    addMappings data, "metadata-70002762fc3e" , { is: 'Metadata' , title : 'iOS'                       , xref    : ['xref-80002762fc3e']}
    addMappings data, "metadata-11002762fc3e" , { is: 'Metadata' , title : 'Web Application'           , xref    : ['xref-17002762fc3e']}
    

    
    # Phase (Metadata)
    addMappings data, "query-00302762fc3e"    , { is: 'Query'    , title : 'Phase'                     , contains: ['metadata-40002762fc3e'
                                                                                                                    'metadata-90002762fc3e']}
                                                                                                                    
    addMappings data, "metadata-40002762fc3e" , { is: 'Metadata' , title : 'Implementation'            , xref    : ['xref-10002762fc3e'   
                                                                                                                    'xref-50002762fc3e'
                                                                                                                    'xref-90002762fc3e'
                                                                                                                    'xref-18002762fc3e'
                                                                                                                    'xref-23002762fc3e']}
                                                                                                                    
    addMappings data, "metadata-90002762fc3e" , { is: 'Metadata' , title : 'Design'                    , xref    : ['xref-14002762fc3e'
                                                                                                                    'xref-27002762fc3e']}
        
    # Type (Metadata)
    addMappings data, "query-00202762fc3e"    , { is: 'Query'    , title : 'Type'                      , contains: ['metadata-50002762fc3e'
                                                                                                                    'metadata-12002762fc3e']}
    addMappings data, "metadata-50002762fc3e" , { is: 'Metadata' , title : 'Checklist Item'            , xref    : ['xref-20002762fc3e'
                                                                                                                    'xref-60002762fc3e'
                                                                                                                    'xref-11002762fc3e'
                                                                                                                    'xref-15002762fc3e'
                                                                                                                    'xref-24002762fc3e'
                                                                                                                    'xref-28002762fc3e']}
                                                                                                                    
    addMappings data, "metadata-12002762fc3e" , { is: 'Metadata' , title : 'Guideline'                 , xref    : ['xref-19002762fc3e']}
    
    # Category (Metadata)
    addMappings data, "query-00402762fc3e"    , { is: 'Query'    , title : 'Category'                  , contains: ['metadata-60002762fc3e']}
    addMappings data, "metadata-60002762fc3e" , { is: 'Metadata' , title : 'Input and Data Validation' , xref    : ['xref-30002762fc3e'
                                                                                                                    'xref-70002762fc3e'    
                                                                                                                    'xref-12002762fc3e'
                                                                                                                    'xref-16002762fc3e'
                                                                                                                    'xref-21002762fc3e'
                                                                                                                    'xref-25002762fc3e'
                                                                                                                    'xref-29002762fc3e']}
    
    
    # Xrefs
    addMappings data, "xref-00002762fc3e"   ,  { is: 'XRef',    target: 'article-e7ed2762fc3e' , weight: '10'}
    addMappings data, "xref-10002762fc3e"   ,  { is: 'XRef',    target: 'article-e7ed2762fc3e' , weight: '5' }
    addMappings data, "xref-20002762fc3e"   ,  { is: 'XRef',    target: 'article-e7ed2762fc3e' , weight: '3' }
    addMappings data, "xref-30002762fc3e"   ,  { is: 'XRef',    target: 'article-e7ed2762fc3e' , weight: '1' }
    
    addMappings data, "xref-40002762fc3e"   ,  { is: 'XRef',    target: 'article-d5bc580df781' , weight: '3' }
    addMappings data, "xref-50002762fc3e"   ,  { is: 'XRef',    target: 'article-d5bc580df781' , weight: '3' }
    addMappings data, "xref-60002762fc3e"   ,  { is: 'XRef',    target: 'article-d5bc580df781' , weight: '3' }
    addMappings data, "xref-70002762fc3e"   ,  { is: 'XRef',    target: 'article-d5bc580df781' , weight: '3' }
    
    addMappings data, "xref-80002762fc3e"   ,  { is: 'XRef',    target: 'article-9771b8ed3eda' , weight: '3' }
    addMappings data, "xref-90002762fc3e"   ,  { is: 'XRef',    target: 'article-9771b8ed3eda' , weight: '3' }
    addMappings data, "xref-11002762fc3e"   ,  { is: 'XRef',    target: 'article-9771b8ed3eda' , weight: '5' }
    addMappings data, "xref-12002762fc3e"   ,  { is: 'XRef',    target: 'article-9771b8ed3eda' , weight: '3' }
    
    addMappings data, "xref-13002762fc3e"   ,  { is: 'XRef',    target: 'article-1106d793193b' , weight: '1' }
    addMappings data, "xref-14002762fc3e"   ,  { is: 'XRef',    target: 'article-1106d793193b' , weight: '3' }
    addMappings data, "xref-15002762fc3e"   ,  { is: 'XRef',    target: 'article-1106d793193b' , weight: '3' }
    addMappings data, "xref-16002762fc3e"   ,  { is: 'XRef',    target: 'article-1106d793193b' , weight: '2' }
    
    addMappings data, "xref-17002762fc3e"   ,  { is: 'XRef',    target: 'article-3e15eef3a23c' , weight: '3' }
    addMappings data, "xref-18002762fc3e"   ,  { is: 'XRef',    target: 'article-3e15eef3a23c' , weight: '4' }
    addMappings data, "xref-19002762fc3e"   ,  { is: 'XRef',    target: 'article-3e15eef3a23c' , weight: '3' }    
    addMappings data, "xref-21002762fc3e"   ,  { is: 'XRef',    target: 'article-3e15eef3a23c' , weight: '3' }
    
    addMappings data, "xref-22002762fc3e"   ,  { is: 'XRef',    target: 'article-9f8b44a5b27d' , weight: '3' }
    addMappings data, "xref-23002762fc3e"   ,  { is: 'XRef',    target: 'article-9f8b44a5b27d' , weight: '1' }
    addMappings data, "xref-24002762fc3e"   ,  { is: 'XRef',    target: 'article-9f8b44a5b27d' , weight: '3' }
    addMappings data, "xref-25002762fc3e"   ,  { is: 'XRef',    target: 'article-9f8b44a5b27d' , weight: '1' }
    
    addMappings data, "xref-26002762fc3e"   ,  { is: 'XRef',    target: 'article-46d6939abe45' , weight: '3' }
    addMappings data, "xref-27002762fc3e"   ,  { is: 'XRef',    target: 'article-46d6939abe45' , weight: '3' }
    addMappings data, "xref-28002762fc3e"   ,  { is: 'XRef',    target: 'article-46d6939abe45' , weight: '1' }
    addMappings data, "xref-29002762fc3e"   ,  { is: 'XRef',    target: 'article-46d6939abe45' , weight: '3' }
    
    addMappings data, "xref-31002762fc3e"   ,  { is: 'XRef',    target: 'article-e7ed2762fc3e' , weight: '1' }
    addMappings data, "xref-32002762fc3e"   ,  { is: 'XRef',    target: 'article-d5bc580df781' , weight: '1' }
    addMappings data, "xref-33002762fc3e"   ,  { is: 'XRef',    target: 'article-9771b8ed3eda' , weight: '3' }
    addMappings data, "xref-34002762fc3e"   ,  { is: 'XRef',    target: 'article-1106d793193b' , weight: '3' }
    addMappings data, "xref-35002762fc3e"   ,  { is: 'XRef',    target: 'article-3e15eef3a23c' , weight: '6' }
    addMappings data, "xref-36002762fc3e"   ,  { is: 'XRef',    target: 'article-9f8b44a5b27d' , weight: '6' }
    addMappings data, "xref-37002762fc3e"   ,  { is: 'XRef',    target: 'article-46d6939abe45' , weight: '9' }
    
    addMappings data, "xref-38002762fc3e"   ,  { is: 'XRef',    target: 'article-e7ed2762fc3e' , weight: '1' }
    addMappings data, "xref-39002762fc3e"   ,  { is: 'XRef',    target: 'article-d5bc580df781' , weight: '1' }
    addMappings data, "xref-41002762fc3e"   ,  { is: 'XRef',    target: 'article-9771b8ed3eda' , weight: '3' }
    addMappings data, "xref-42002762fc3e"   ,  { is: 'XRef',    target: 'article-1106d793193b' , weight: '3' }
    addMappings data, "xref-43002762fc3e"   ,  { is: 'XRef',    target: 'article-3e15eef3a23c' , weight: '6' }
    addMappings data, "xref-44002762fc3e"   ,  { is: 'XRef',    target: 'article-9f8b44a5b27d' , weight: '6' }
    addMappings data, "xref-45002762fc3e"   ,  { is: 'XRef',    target: 'article-46d6939abe45' , weight: '9' }
    
    db.put data , callback    

module.exports = addData