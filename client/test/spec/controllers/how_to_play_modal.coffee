'use strict'

describe 'Controller: HowToPlayModalCtrl', ->
  beforeEach module 'blicblockApp'

  HowToPlayModalCtrl = {}
  scope = {}
  rootScope = {}

  beforeEach inject ($injector, $controller, $rootScope) ->
    rootScope = $rootScope
    scope = $rootScope.$new()
    modal = $injector.get('$modal')
    HowToPlayModalCtrl = $controller 'HowToPlayModalCtrl',
      $scope: scope
      $rootScope: $rootScope
      $modal: modal

  describe 'open', ->
    it 'broadcasts pause', ->
      spyOn rootScope, '$broadcast'
      scope.open()
      expect(rootScope.$broadcast).toHaveBeenCalledWith 'pause'
