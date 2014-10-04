'use strict'

describe 'Service: Score', ->
  beforeEach module 'blicblockApp'

  Score = {}
  httpBackend = {}

  beforeEach inject ($injector) ->
    Score = $injector.get('Score')
    httpBackend = $injector.get('$httpBackend')

  it 'is defined', ->
    expect(Score).toBeDefined()

  describe 'query', ->
    it 'gets list of scores', ->
      httpBackend.expectGET('/api/scores.json')
                 .respond([{value: 1000, initials: 'ABC'}])
      results = Score.query()
      httpBackend.flush()
      expect(results[0].value).toEqual(1000)
      expect(results[0].initials).toEqual('ABC')
