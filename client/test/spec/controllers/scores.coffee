'use strict'

describe 'Controller: ScoresCtrl', ->

  # load the controller's module
  beforeEach module 'blicblockApp'

  ScoresCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ScoresCtrl = $controller 'ScoresCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
