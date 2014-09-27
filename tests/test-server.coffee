supertest = require('supertest')
expect    = require('chai').expect
server    = require('./../src/server')

describe 'server',->
    it 'check ctor', ->
        expect(server     ).to.be.an('Function')
        console.log 'in ctor'
        
    it 'check route: /', (done)->    
        supertest(server).get('/')
                      .expect(200, 'hello', done)
