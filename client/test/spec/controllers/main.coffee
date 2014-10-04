'use strict'

describe 'Controller: MainCtrl', ->
  beforeEach module 'blicblockApp'

  MainCtrl = {}
  Tetromino = {}
  scope = {}

  beforeEach inject ($injector, $controller, $rootScope) ->
    Tetromino = $injector.get('Tetromino')
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl',
      $scope: scope
      Tetromino: Tetromino

  it 'initializes an empty list of blocks', ->
    expect(scope.blocks).toEqual Tetromino.blocks
    expect(scope.blocks.length).toEqual 0

  it 'initializes a list of upcoming blocks', ->
    expect(scope.upcoming.length).toEqual 2

  it 'initializes game state', ->
    expect(scope.game_info).toEqual Tetromino.info

  it 'initializes an empty object for new high score', ->
    expect(scope.new_high_score).toEqual {}
