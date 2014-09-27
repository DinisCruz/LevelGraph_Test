levelgraph = require('levelgraph'   )
expect     = require('chai'         ).expect
spawn      = require('child_process').spawn
    
describe 'Using bigged db |', ->

    dbPath      = "./tmpDb"
    db          = null
    iMax        = 1
    jMax        = 16000
    deleteData  = true    

    createDb =            -> db = levelgraph(dbPath)
        
    closeDB  = (callback) -> db.close(callback)

    deleteDb = (callback) -> spawn('rm', ['-Rv',dbPath]).on('close', -> callback())

    addData  = (callback) ->
                             data = []
                             for i in [1..iMax]
                                 for j in [1..jMax]
                                    data.push({ subject: i   , predicate: 'mapped'      , object: j})                             
                             console.log "data items to add: #{data.length}"
                             db.put(data, callback)
    
    getAllData =  (callback)->    
        that = this
        db.search [{
                        subject  : db.v("subject"),
                        predicate: db.v("predicate"),
                        object   : db.v("object"),
                    }], callback

    getAllSubject= (id, callback) ->
        db.get subject: id , callback
        
        
    it 'create and populate db', (done)->
        createDb()    
        getAllData (err, data) ->                                    
                                    if data.length != (iMax * jMax) 
                                        addData(done)
                                    else 
                                        done()
                                        
                                        
                                    

    it 'allData', (done)->        
        getAllData (err, data)->
                                expect(data.length).to.equal(iMax * jMax)                                
                                done()
                                
    it 'get_id', (done)->
        getAllSubject '1',
                      (err, data)->
                                    #console.log(data)
                                    done()    
#    it 'search_id', (done)->
#        get_Id '1',
#               (err, data)->
#                              console.log(data)
#                              done()      
                              
    it 'close and delete db', (done)->
        closeDB ->
            if (deleteData)
                deleteDb(done) 
            else
                done()