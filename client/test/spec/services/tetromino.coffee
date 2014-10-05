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

  describe 'setup_cascade', ->
    it 'empties list of blocks', ->
      Tetromino.blocks = ['whee', 'test', 'okay']
      Tetromino.setup_cascade()
      expect(Tetromino.blocks.length).toEqual 0

  describe 'get_active_block', ->
    active_block = {}
    other_block = {}

    beforeEach ->
      active_block = new Block({color: 'magenta', x: 0, y: 2})
      other_block = new Block({color: 'green', x: 3, y: 1, active: false, locked: true})
      Tetromino.blocks = [other_block, active_block]

    it 'returns active block', ->
      expect(Tetromino.get_active_block()).toEqual active_block

  describe 'get_middle_column_blocks', ->
    beforeEach ->
      Tetromino.blocks.push new Block({color: 'blue', x: 0, y: 2})
      Tetromino.blocks.push new Block({color: 'blue', x: 1, y: 2})
      Tetromino.blocks.push new Block({color: 'blue', x: 1, y: 3})
      Tetromino.blocks.push new Block({color: 'blue', x: 4, y: 0})

    it 'returns only blocks in middle column', ->
      actual = Tetromino.get_middle_column_blocks()
      expect(actual.length).toEqual 2
      expect((b.y for b in actual)).toEqual [2, 2]

  describe 'is_block_directly_below', ->
    it 'returns truish when block is directly below given coords', ->
      Tetromino.blocks.push new Block({color: 'blue', x: 1, y: 4})
      expect(Tetromino.is_block_directly_below(0, 4)).toBeTruthy()

    it 'returns falsish when no block is below given coords', ->
      Tetromino.blocks.push new Block({color: 'blue', x: 1, y: 4})
      expect(Tetromino.is_block_directly_below(0, 3)).toBeFalsy()

    it 'returns falsish when there are no blocks', ->
      expect(Tetromino.is_block_directly_below(1, 1)).toBeFalsy()
