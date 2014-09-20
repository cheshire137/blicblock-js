'use strict'

describe 'Directive: ngLeft', ->

  # load the directive's module
  beforeEach module 'blicblockApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<ng-left></ng-left>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the ngLeft directive'
