'use strict'

describe 'Service: Tetromino', ->
  beforeEach module 'blicblockApp'

  Tetromino = {}

  beforeEach inject ($injector) ->
    Tetromino = $injector.get('Tetromino')

  it 'is defined', ->
    expect(Tetromino).toBeDefined()

  it 'initializes an empty array of blocks', ->
    expect(Tetromino.blocks.length).toEqual 0
