expect               = require('chai').expect
SearchDataController = require('./../src/SearchDataController')

describe 'SearchData_Controller',->
    searchDataController = new SearchDataController()
    after ->
        #searchDataController.articlesGraph.level.close()
        
    it 'check ctor', ->
        expect(SearchDataController).to.be.an('Function')
        expect(searchDataController).to.be.an('Object')
        expect(searchDataController.articlesGraph).to.be.an('Object')
    
    it 'mapRoutes', ->
        routesAdded    = []
        expectedRoutes = ['/dataFilePath', '/data.json', '/searchGraph.json']
        server = { get: (route, callback)-> routesAdded.push(route)}
        searchDataController.mapRoutes(server)
        expect(routesAdded).to.deep.equal(expectedRoutes)
    
        
        
        
        
        