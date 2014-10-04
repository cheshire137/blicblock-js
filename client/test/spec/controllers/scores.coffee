'use strict'

describe 'Controller: ScoresCtrl', ->
  beforeEach module 'blicblockApp'

  Score = {}
  ScoresCtrl = {}
  scope = {}
  httpBackend = {}

  beforeEach inject ($injector, $controller, $rootScope) ->
    scope = $rootScope.$new()
    Score = $injector.get('Score')
    httpBackend = $injector.get('$httpBackend')
    ScoresCtrl = $controller 'ScoresCtrl',
      $scope: scope
      Score: Score

  it 'sets up score filters', ->
    expect(scope.filters).toBeDefined()

  it 'queries list of scores', ->
    httpBackend.expectGET('/api/scores.json?initials=&order=value&time=month')
               .respond([{value: 1000, initials: 'ABC'}])
    httpBackend.flush()
    expect(scope.scores).toBeDefined()
    expect(scope.scores[0].value).toEqual(1000)
    expect(scope.scores[0].initials).toEqual('ABC')
