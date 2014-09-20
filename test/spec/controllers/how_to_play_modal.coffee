'use strict'

describe 'Controller: HowToPlayModalCtrl', ->

  # load the controller's module
  beforeEach module 'blicblockApp'

  HowToPlayModalCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    HowToPlayModalCtrl = $controller 'HowToPlayModalCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
