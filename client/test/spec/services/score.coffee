'use strict'

describe 'Service: score', ->

  # load the service's module
  beforeEach module 'blicblockApp'

  # instantiate service
  score = {}
  beforeEach inject (_score_) ->
    score = _score_

  it 'should do something', ->
    expect(!!score).toBe true
