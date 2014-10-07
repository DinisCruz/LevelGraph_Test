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
                            expect($("a").length).to.equal(8)
                            done()
    
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
                             .expect('Access-Control-Allow-Origin', '*')
                             .expect(200)
                             .end (error, response) ->
                                    throw error if error
                                    expect(response.text).to.contain('"subject": "1106d793193b')
                                    done()


        it '/searchData.json', (done)->
            supertest(server).get('/searchData.json')
                          .expect(200)
                          .expect('Content-Type', /json/)
                          .end (error, response) ->                                
                                expect(response.text).to.contain('"title": "Data Validation"')
                                done()  
                
        it '/query', (done)->
            key  = "object"
            value = "Design"
            supertest(server).get("/query/#{key}/#{value}")
                          .expect(200)
                          .expect('Content-Type', /json/)
                          .end (error, response) ->
                                throw error if error
                                expect(response.text).to.contain(key)
                                expect(response.text).to.contain(value)
                                done()
        it '/view', (done)->
            key  = "object"
            value = "Design"
            supertest(server).get("/view/#{key}/#{value}")
                             .expect(200)
                             .expect('Content-Type', /html/)
                             .end (error, response) ->
                                    throw error if error
                                    $ = cheerio.load(response.text)
                                    expect($('a').length).to.equal(12)
                                    subject   = $('#subject')
                                    predicate = $('#predicate')
                                    object    = $('#object')
                                    expect(subject  .html()).to.equal('1106d793193b')
                                    expect(predicate.html()).to.equal('Phase')
                                    expect(object   .html()).to.equal('Design')                                                                
                                    expect(subject  .attr('href')).to.equal('/view/subject/1106d793193b')
                                    expect(predicate.attr('href')).to.equal('/view/predicate/Phase')
                                    expect(object   .attr('href')).to.equal('/view/object/Design')
                                    done()
        it '/rawGraphData.json', (done) ->
            supertest(server).get("/rawGraphData.json")
                             .expect(201)
                             .expect('Content-Type', /json/)
                             .end (error, response) ->
                                expect(response.text).to.be.an('String')
                                data = JSON.parse(response.text)
                                expect(data.nodes).to.be.an('Array')
                                expect(data.edges).to.be.an('Array')
                                done()