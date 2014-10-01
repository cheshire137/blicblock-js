'use strict'

describe 'Service: tetromino', ->

  # load the service's module
  beforeEach module 'blicblockApp'

  # instantiate service
  tetromino = {}
  beforeEach inject (_tetromino_) ->
    tetromino = _tetromino_

  it 'should do something', ->
    expect(!!tetromino).toBe true
