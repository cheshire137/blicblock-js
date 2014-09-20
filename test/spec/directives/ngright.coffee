'use strict'

describe 'Directive: ngRight', ->

  # load the directive's module
  beforeEach module 'blicblockApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<ng-right></ng-right>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the ngRight directive'
