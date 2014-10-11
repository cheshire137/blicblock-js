'use strict'

describe 'Service: Country', ->
  beforeEach module 'blicblockApp'

  Country = {}
  httpBackend = {}

  beforeEach inject ($injector) ->
    Country = $injector.get('Country')
    httpBackend = $injector.get('$httpBackend')

  it 'is defined', ->
    expect(Country).toBeDefined()

  describe 'query', ->
    it 'gets list of country names and codes', ->
      httpBackend.expectGET('/api/scores/countries.json').
                  respond [{name: 'United States', code: 'us'},
                           {name: 'Canada', code: 'ca'}]
      results = Country.query()
      httpBackend.flush()
      expect(results[0].name).toEqual('United States')
      expect(results[0].code).toEqual('us')
      expect(results[1].name).toEqual('Canada')
      expect(results[1].code).toEqual('ca')
