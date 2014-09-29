require('fluentnode')
fs            = require('fs'           )
expect        = require('chai'         ).expect
spawn         = require('child_process').spawn
ArticlesGraph = require('./../src/ArticlesGraph')

describe 'test-Articles-Graph |', ->
    articlesGraph  = new ArticlesGraph()    
    
    beforeEach ()->
        articlesGraph.openDb()

    afterEach (done)->
        articlesGraph.closeDb(done)        
        
    after (done) ->        
        done()
    
    it 'deleteDb', (done) ->
        articlesGraph.closeDb ->    
            expect(articlesGraph.dbPath.fileExists()).to.be.true
            spawn('rm', ['-Rv',articlesGraph.dbPath])
                .on 'exit', (code, signal) ->                     
                    expect(articlesGraph.dbPath.fileExists()).to.be.false
                    done()
        
    it 'check ctor',->
        expect(ArticlesGraph       ).to.be.an('Function')
        expect(articlesGraph       ).to.be.an('Object'  )
        expect(articlesGraph.dbPath).to.be.an('String'  )
        expect(articlesGraph.level ).to.be.an('Object'  )
        expect(articlesGraph.db    ).to.be.an('Object'  )

    
    
    it 'dataFilePath',->
        expect(              articlesGraph.dataFilePath   ).to.be.an('Function')
        expect(              articlesGraph.dataFilePath() ).to.be.an('String')
        expect(fs.existsSync(articlesGraph.dataFilePath())).to.be.true
    
    it 'dataFromFile', ->
        expect(              articlesGraph.dataFromFile   ).to.be.an('Function')
        data = articlesGraph.dataFromFile()
        expect(data        ).to.be.an('Array')
        expect(data        ).to.not.be.empty
        expect(data.first()).to.not.be.empty
        
        expect(data.first().subject).to.be.an('String')
        expect(data.first().predicate).to.be.an('String')
        expect(data.first().object).to.be.an('String')
    
    it 'loadTestData', (done)->
        expect(articlesGraph.loadTestData).to.be.an('Function')
        articlesGraph.loadTestData () ->
                                            expect(articlesGraph.data).to.not.be.empty
                                            expect(articlesGraph.data.length).to.be.above(50)
                                            #articlesGraph.closeDb()
                                            done()
                                
    it 'alldata', (done)->
        expect(articlesGraph.allData).to.be.an('Function')
        articlesGraph.allData  (err, data) ->
                                                expect(data.length).to.equal(articlesGraph.data.length)
                                                done()
    it 'query', (done)->
        expect(articlesGraph.query).to.be.an('Function')
        
        items = [{ key : "subject"  , value: "bcea0b7ace25" , hasResults:true }
                 { key : "subject"  , value: "...."         , hasResults:false}
                 { key : "predicate", value: "View"         , hasResults:true }
                 { key : "predicate", value: "...."         , hasResults:false}
                 { key : "object"   , value: "Design"       , hasResults:true }]
        #items = []
        checkItem = ->
            if(items.empty())
                done()
            else
                item = items.pop()
                articlesGraph.query item.key, item.value, (err, data)->
                    if (item.hasResults)
                        expect(data).to.not.be.empty
                        expect(data.json()).to.contain(item.key)
                        expect(data.json()).to.contain(item.value)
                    else
                        expect(data).to.be.empty
                    checkItem()
        checkItem()

    it 'articlesInView_by_Id', (done)->
        expect(articlesGraph.articlesInView_by_Id).to.be.an('Function')
        viewId = 'bcea0b7ace25'      
        articlesGraph.articlesInView_by_Id viewId,
                                           (err,data) ->
                                                        expect(data.length).to.equal(5)
                                                        #console.log JSON.stringify(data,null,'  ')
                                                        done()
    it 'articlesInView_by_Name', (done)->
        expect(articlesGraph.articlesInView_by_Name).to.be.an('Function')
        viewName = 'Validate All Input'
        articlesGraph.articlesInView_by_Name viewName,
                                             (err,data) ->
                                                            expect(data.length).to.be.above(32)
                                                            #for item in data
                                                            #    console.log(">  subject: #{item.subject} , predicate: #{item.predicate}  object: #{item.object}")
                                                            #console.log JSON.stringify(data,null,'  ')
                                                            done()
     it 'searchGraph' , (done)->
        expect(articlesGraph.searchGraph       ).to.be.an('Function')
        articlesGraph.searchGraph 'Data Validation',
                                  (err, data) ->
                                            #console.log(data)
                                            expect(data.length).to.be.above(20)
                                            #console.log "got #{data.length} results"
                                            done()
     
     it 'createSearchData' , (done)->
            
        viewName          = 'Data Validation'
        container_Title   = 'Perform Validation on the Server'
        container_Id      = '4eef2c5f-7108-4ad2-a6b9-e6e84097e9e0'
        container_Size    = 3
        resultsTitle      = '8/8 results showing'
        result_Title      = 'Client-side Validation Is Not Relied On';
        result_Link       = 'https://tmdev01-sme.teammentor.net/9607b6e3-de61-4ff7-8ef0-9f8b44a5b27d'
        result_Id         = '9607b6e3-de61-4ff7-8ef0-9f8b44a5b27d'
        result_Summary    = 'Verify that the same or more rigorous checks are performed on the server as on the client. Verify that client-side validation is used only for usability and to reduce the number of posts to the server.'
        result_Score      = 0
        view_Title        = 'Technology'
        view_result_Title = 'ASP.NET 4.0'
        view_result_Size  = 1
        
        checkSearchData = (data)->
            
            expect(data             ).to.be.an('Object')
            expect(data.title       ).to.be.an('String')
            expect(data.containers  ).to.be.an('Array' )
            expect(data.resultsTitle).to.be.an('String')
            expect(data.results     ).to.be.an('Array' )
            expect(data.filters     ).to.be.an('Array' )
                        
            expect(data.title                   ).to.equal(viewName)
            expect(data.containers.first().title).to.equal(container_Title)
            expect(data.containers.first().id   ).to.equal(container_Id   )
            expect(data.containers.first().size ).to.equal(container_Size )      
            expect(data.resultsTitle            ).to.equal(resultsTitle   )
            expect(data.results.first().title   ).to.equal(result_Title)
            expect(data.results.first().link    ).to.equal(result_Link)
            expect(data.results.first().id      ).to.equal(result_Id)
            expect(data.results.first().summary ).to.equal(result_Summary)
            expect(data.results.first().score   ).to.equal(result_Score)
                                
            firstFilter = data.filters.first()
            expect(firstFilter.title                ).to.equal(view_Title)
            expect(firstFilter.results              ).to.be.an('Array' )
            expect(firstFilter.results.first().title).to.equal(view_result_Title)
            expect(firstFilter.results.first().size ).to.equal(view_result_Size)

            done()
        
        articlesGraph.createSearchData viewName, checkSearchData