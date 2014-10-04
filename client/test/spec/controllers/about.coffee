'use strict'

describe 'Controller: AboutCtrl', ->
  beforeEach module 'blicblockApp'

  AboutCtrl = {}
  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AboutCtrl = $controller 'AboutCtrl', {
      $scope: scope
    }
