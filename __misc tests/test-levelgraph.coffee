levelgraph = require('levelgraph')
expect     = require('chai').expect
spawn      = require('child_process').spawn
    
describe 'test-levelgraph', ->
    
    db = null
    
    before ->
        console.log 'before all'
    beforeEach ->
        db = levelgraph('yourdb')
        
    afterEach (done)->
        db.close(done)
    
    after ->
        spawn('rm', ['-Rv','yourdb'])
            .stdout.on('data', (data) -> console.log('Deleting files: ' + data))
    #    spawn('rm', ['-Rv','testStream'])
    #        .stdout.on('data', (data) -> console.log('Deleting files: ' + data))


    it 'check db was created ok', ()->
        expect(db       ).to.be.an('Object')
        expect(db.put   ).to.be.an('Function')
        expect(db.get   ).to.be.an('Function')
        expect(db.search).to.be.an('Function')
        
    it 'add a tripple', (done)->
        triple = { subject: 'a', predicate: 'b', object: 'c' }
        db.put(triple, (err) ->
                                throw err if err
                                done()
              )
            
    it 'add another triple', (done)->
        triple = { subject: 'd', predicate: 'b', object: 'e' }
        db.put(triple, done)
        
    it 'get subject: a', (done) ->
        subject = db.get( { subject: 'a'} ,
                          (err, list) ->
                                        expect(list).to.deep.equal([ { subject: 'a', predicate: 'b', object: 'c' } ])
                                        done()
                        )
    it 'get subject: d', (done) ->
        subject = db.get( { subject: 'd'} ,
                          (err, list) ->
                                        expect(list).to.deep.equal([ { subject: 'd', predicate: 'b', object: 'e' } ])
                                        done()
                        )
    it 'get object: c', (done) ->
        subject = db.get( { object: 'c'} ,
                          (err, list) ->
                                        expect(list).to.deep.equal([ { subject: 'a', predicate: 'b', object: 'c' } ])
                                        done()
                        )
    it 'get predicate: b', (done) ->
        subject = db.get( { predicate: 'b'} ,
                          (err, list) ->
                                        expect(list).to.deep.equal([ { subject: 'a', predicate: 'b', object: 'c' },
                                                                     { subject: 'd', predicate: 'b', object: 'e' } ])
                                        done()
                        )
    
    #not working as expected
    xit 'test stream', (done) ->
        loggedData = []
        streamDb = levelgraph('testStream')
        getStream = streamDb.getStream({ predicate: "b" })
        getStream.on("data", (data) ->
                                        loggedData.push(data)
                                        console.log data
                                        if loggedData.length ==2
                                            expect(loggedData).to.deep.equal([ { subject: 'AAA', predicate: 'b', object: 'f' },
                                                                               { subject: 'BBB', predicate: 'b', object: 'f' } ])
                                            streamDb.close(done)
                    )
        putStream = streamDb.putStream()
        triple1 = { subject: 'AAA', predicate: 'b', object: 'f' }
        triple2 = { subject: 'BBB', predicate: 'b', object: 'f' }
        putStream.write(triple1)
        putStream.end  (triple2)
            
        
        
        
