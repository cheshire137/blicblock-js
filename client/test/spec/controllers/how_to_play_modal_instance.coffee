'use strict'

describe 'Controller: HowToPlayModalInstanceCtrl', ->
  beforeEach module 'blicblockApp'

  HowToPlayModalInstanceCtrl = {}
  scope = {}
  modalInstance = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    modalInstance =
      close: jasmine.createSpy('modalInstance.close')
      dismiss: jasmine.createSpy('modalInstance.dismiss')
      result:
        then: jasmine.createSpy('modalInstance.result.then')
    HowToPlayModalInstanceCtrl = $controller 'HowToPlayModalInstanceCtrl',
      $scope: scope
      $modalInstance: modalInstance

  describe 'ok', ->
    it 'closes modal', ->
      scope.ok()
      expect(modalInstance.close).toHaveBeenCalled()

  describe 'cancel', ->
    it 'dismisses modal', ->
      scope.cancel()
      expect(modalInstance.dismiss).toHaveBeenCalledWith 'cancel'
