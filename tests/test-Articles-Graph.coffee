expect        = require('chai'         ).expect
spawn         = require('child_process').spawn
ArticlesGraph = require('./../src/ArticlesGraph') 

describe 'test-Articles-Graph |', ->

    articlesGraph  = new ArticlesGraph()
    deleteDbOnExit = true
    
    after (done) ->
        articlesGraph.level.close ->            # close levelup
            articlesGraph.db.close(done)        # close levelgraoh
        if deleteDbOnExit
            #console.log 'Deleting the articleDB'
            spawn('rm', ['-Rv',articlesGraph.dbPath])
            .stdout.on 'data', (data) -> #console.log('Deleting files: ' + data)
        
    it 'check ctor',->
        expect(ArticlesGraph       ).to.be.an('Function')
        expect(articlesGraph       ).to.be.an('Object'  )
        expect(articlesGraph.dbPath).to.be.an('String'  )
        expect(articlesGraph.level ).to.be.an('Object'  )
        expect(articlesGraph.db    ).to.be.an('Object'  )
    
    it 'loadTestData', (done)->
        expect(articlesGraph.loadTestData).to.be.an('Function')
        articlesGraph.loadTestData () ->
                                            expect(articlesGraph.data).to.not.be.empty
                                            expect(articlesGraph.data.length).to.be.above(50)
                                            done()
    
    it 'alldata', (done)->
        expect(articlesGraph.allData).to.be.an('Function')
        articlesGraph.allData  (err, data) ->
                                                expect(data.length).to.equal(articlesGraph.data.length)
                                                #console.log(data)
                                                done()
    
    it 'articlesInView_by_Id', (done)->
        expect(articlesGraph.articlesInView_by_Id).to.be.an('Function')
        viewId = 'bcea0b7ace25'
        viewId = 'bcea0b7ace25'
        articlesGraph.articlesInView_by_Id viewId,
                                           (err,data) ->
                                                        #console.log JSON.stringify(data,null,'  ')
                                                        done()
    it 'articlesInView_by_Name', (done)->
        expect(articlesGraph.articlesInView_by_Name).to.be.an('Function')
        viewName = 'Validate All Input'
        articlesGraph.articlesInView_by_Name viewName,
                                             (err,data) ->
                                                            #for item in data
                                                            #    console.log(">  subject: #{item.subject} , predicate: #{item.predicate}  object: #{item.object}")
                                                            #console.log JSON.stringify(data,null,'  ')
                                                            done()
     it 'createSearchData' , (done)->
        expect(articlesGraph.createSearchData       ).to.be.an('Function')
        articlesGraph.createSearchData 'Data Validation',
                                        (data) ->
                                                        console.log "got #{data.length} results"
                                                        #console.log JSON.stringify(data,null,'  ')
                                                        done()

###