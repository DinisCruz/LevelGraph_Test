require('fluentnode')
fs            = require('fs'           )
expect        = require('chai'         ).expect
spawn         = require('child_process').spawn
ArticlesGraph = require('./../src/ArticlesGraph')

describe 'test-Articles-Graph |', ->
    articlesGraph  = new ArticlesGraph()
    deleteDbOnExit = false
    
    beforeEach ()->
        #console.log '>>>>>>>>>>>>'
        articlesGraph.openDb()

    afterEach (done)->
        articlesGraph.closeDb(done)
        #console.log '<<<<<<<<<<<'
        
    after (done) ->
        #articlesGraph.level.close ->            # close levelup
        #    articlesGraph.db.close(done)        # close levelgraoh
        if deleteDbOnExit
            #console.log 'Deleting the articleDB'
            spawn('rm', ['-Rv',articlesGraph.dbPath])
            #.stdout.on 'data', (data) -> #console.log('Deleting files: ' + data)
        done()
    
    it 'check ctor',->
        expect(ArticlesGraph       ).to.be.an('Function')
        expect(articlesGraph       ).to.be.an('Object'  )
        #expect(articlesGraph.dbPath).to.be.an('String'  )
        expect(articlesGraph.level ).to.be.an('Object'  )
        expect(articlesGraph.db    ).to.be.an('Object'  )
        #expect(articlesGraph.db    ).to.equal(null)

    
    
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
        #done();
        
        ###checkObject = (next)->
        #articlesGraph.query "subject","Technology", (err, data) ->
        articlesGraph.query "object", "bcea0b7ace25", (err, data) ->
            
            console.log(data.length)
            console.log(data)
            done()
        ###    
            
    
    it 'articlesInView_by_Id', (done)->
        expect(articlesGraph.articlesInView_by_Id).to.be.an('Function')
        viewId = 'bcea0b7ace25'
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
                                                            expect(data.length).to.equal(32)
                                                            #for item in data
                                                            #    console.log(">  subject: #{item.subject} , predicate: #{item.predicate}  object: #{item.object}")
                                                            #console.log JSON.stringify(data,null,'  ')
                                                            done()
     it 'searchGraph' , (done)->
        expect(articlesGraph.searchGraph       ).to.be.an('Function')
        articlesGraph.searchGraph 'Data Validation',
                                  (err, data) ->
                                            expect(data.length).to.be.above(20)
                                            console.log "got #{data.length} results"
                                            done()
     it 'createSearchData' , (done)->
        articlesGraph.createSearchData 'Data Validation',
                                        (data) ->
                                                    expect(data.length).to.be.above(20)
                                                    console.log "got #{data.length} results"
                                                    done()

###