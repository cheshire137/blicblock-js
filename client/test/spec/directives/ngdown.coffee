'use strict'

describe 'Directive: ngDown', ->

  # load the directive's module
  beforeEach module 'blicblockApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<ng-down></ng-down>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the ngDown directive'
