'use strict'

describe 'Service: Score', ->
  beforeEach module 'blicblockApp'

  Score = {}
  beforeEach inject ($injector) ->
    Score = $injector.get('Score')

  it 'is defined', ->
    expect(Score).toBeDefined()
