'use strict'

describe 'Controller: ScoresCtrl', ->
  beforeEach module 'blicblockApp'

  Score = {}
  ScoresCtrl = {}
  scope = {}
  httpBackend = {}
  location = {}

  beforeEach inject ($injector, $controller, $rootScope) ->
    scope = $rootScope.$new()
    Score = $injector.get('Score')
    httpBackend = $injector.get('$httpBackend')
    location = $injector.get('$location')
    ScoresCtrl = $controller 'ScoresCtrl',
      $scope: scope
      Score: Score
    httpBackend.expectGET('/api/scores/countries.json').
                respond [{name: 'United States', code: 'us'},
                         {name: 'Canada', code: 'ca'}]
    httpBackend.expectGET('/api/scores.json?country_code=&initials=' +
                          '&order=value&page=1&time=week')
               .respond
                 scores: [value: 1000, initials: 'ABC']
                 page: 1
                 total_pages: 1
                 total_records: 1
    httpBackend.flush()

  it 'sets up score filters', ->
    expect(scope.filters).toBeDefined()

  it 'queries list of countries', ->
    expect(scope.countries).toBeDefined()
    expect(scope.countries[0].name).toEqual('United States')
    expect(scope.countries[0].code).toEqual('us')
    expect(scope.countries[1].name).toEqual('Canada')
    expect(scope.countries[1].code).toEqual('ca')

  it 'queries list of scores', ->
    expect(scope.score_results).toBeDefined()
    expect(scope.score_results.page).toEqual 1
    expect(scope.score_results.total_pages).toEqual 1
    expect(scope.score_results.total_records).toEqual 1
    expect(scope.score_results.scores[0].value).toEqual 1000
    expect(scope.score_results.scores[0].initials).toEqual 'ABC'

  describe 'filter', ->
    it 'changes location', ->
      scope.filters.time = 'a'
      scope.filters.initials = 'b'
      scope.filters.order = 'c'
      scope.filters.country_code = 'd'
      scope.filters.page = 4
      spyOn(location, 'path')
      scope.filter()
      expect(location.path).toHaveBeenCalledWith('/scores/country/d/initials/b/time/a/order/c/page/4')
