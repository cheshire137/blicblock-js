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

  describe 'remove_all_blocks', ->
    it 'empties list of blocks', ->
      Tetromino.blocks = ['whee', 'test', 'okay']
      Tetromino.remove_all_blocks()
      expect(Tetromino.blocks.length).toEqual 0

  describe 'add_locked_block', ->
    it 'adds a locked, inactive block to the list', ->
      before_count = Tetromino.blocks.length
      Tetromino.add_locked_block 'red', 1, 2
      expect(Tetromino.blocks.length).toEqual before_count + 1
      expect(Tetromino.blocks[before_count].locked).toEqual true
      expect(Tetromino.blocks[before_count].active).toEqual false
