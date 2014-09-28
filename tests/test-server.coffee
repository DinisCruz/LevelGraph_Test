supertest = require('supertest')
cheerio   = require('cheerio')
expect    = require('chai').expect
server    = require('./../src/server')
        
describe 'server |',->
    it 'check ctor', ->
        expect(server                     ).to.be.an('Function')
        expect(server.searchDataController).to.be.an('Object')
        expect(server.get('view engine'  )).to.equal('jade')
    
    describe 'check route |', ->
    
        it '/', (done)->
            supertest(server).get('/')
                          .expect(200)
                          .end (error, response) ->
                            $ = cheerio.load(response.text)
                            expect($('#title').html()).to.equal('LevelGraph TM data')
                            expect($("a").length).to.equal(3)
                            done()
    
    
        #these tests fail on supertest (they hang on sync)
        
        #from searchDataController
        it '/dataFilePath', (done)->
            supertest(server).get('/dataFilePath')
                             .expect(200)
                             .end (error, response) ->
                                expect(response.text).to.contain('article-data.json')
                                done()
        
        it '/data.json', (done)->
            supertest(server).get('/data.json')
                             .expect('Content-Type', /json/)
                             .expect(200)
                             .end (error, response) ->
                                    throw error if error
                                    expect(response.text).to.contain('"subject": "1106d793193b')
                                    done()


        it '/searchGraph.json', (done)->
            supertest(server).get('/searchGraph.json')
                          .expect(200)
                          .expect('Content-Type', /json/)
                          .end (error, response) ->
                                expect(response.text).to.contain(' "viewName": "Data Validation"')
                                done()
