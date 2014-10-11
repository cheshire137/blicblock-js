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
      httpBackend.expectGET('/api/scores.json').respond
        scores: [value: 1000, initials: 'ABC']
        page: 1
        total_pages: 1
        total_records: 1
      results = Score.query()
      httpBackend.flush()
      expect(results.scores[0].value).toEqual(1000)
      expect(results.scores[0].initials).toEqual('ABC')
