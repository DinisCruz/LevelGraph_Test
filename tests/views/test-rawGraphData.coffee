require("fluentnode")
server = require('./../../src/server')
Browser = require('zombie')
expect  = require('chai').expect
assert = require("assert")

describe 'views | test-rawGraphData',->
    
    port       = 3000
    liveServer = null
    browser    = null
    
    before (done)->
        Browser.localhost('localhost', port)
        browser = Browser.create()
        liveServer = server.listen(port)
        browser.visit "/", (error)->
            browser.assert.success()            
            done()

    after (done)->   
        liveServer.close()
        done()
        
    it 'check Server', (done)->                             
        browser.visit "/", (error)->
            browser.assert.success()
            done()      
            
    xit '/vis/vis.js', (done)->                             
        @.timeout(5000)
        browser.visit "/vis/vis.js", (error)->        
        #browser.visit "/__dirname", (error)->
            try
                browser.assert.success()
                #console.log(browser.html())
            catch err
                console.log err
            done()         
    
    it '/rawGraphData (loads ok)', (done)->
        browser.visit "/graphData", (error)->
            try            
                browser.assert.success()
                console.log(browser.html())
            catch err
                console.log err
            done()         
        