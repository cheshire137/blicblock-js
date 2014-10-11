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
    httpBackend.expectGET('/api/scores.json?initials=&order=value&time=week')
               .respond([{value: 1000, initials: 'ABC'}])
    httpBackend.flush()

  it 'sets up score filters', ->
    expect(scope.filters).toBeDefined()

  it 'queries list of scores', ->
    expect(scope.scores).toBeDefined()
    expect(scope.scores[0].value).toEqual(1000)
    expect(scope.scores[0].initials).toEqual('ABC')

  describe 'filter', ->
    it 'makes query with filters', ->
      scope.filters.time = 'a'
      scope.filters.initials = 'b'
      scope.filters.order = 'c'
      httpBackend.expectGET('/api/scores.json?initials=b&order=c&time=a')
                 .respond([{value: 250, initials: 'neato'}])
      scope.filter()
      httpBackend.flush()
      expect(scope.scores).toBeDefined()
      expect(scope.scores[0].value).toEqual(250)
      expect(scope.scores[0].initials).toEqual('neato')
