expect               = require('chai').expect
SearchDataController = require('./../src/SearchDataController')

describe 'SearchData_Controller',->
    searchDataController = new SearchDataController()
        
    it 'check ctor', ->
        expect(SearchDataController).to.be.an('Function')
        expect(searchDataController).to.be.an('Object')
        expect(searchDataController.articlesGraph).to.be.an('Object')
    
    it 'mapRoutes', ->
        routesAdded    = []
        expectedRoutes = ['/dataFilePath'
                          '/data.json'
                          '/searchGraph.json'
                          '/query/:key/'
                          '/query/:key/:value'
                          '/view/:key/'
                          '/view/:key/:value'
                          ]
        server = { get: (route, callback)-> routesAdded.push(route)}
        searchDataController.mapRoutes(server)
        expect(routesAdded).to.deep.equal(expectedRoutes)
    
        
        
        
        
        