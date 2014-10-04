'use strict'

describe 'Directive: ngSpace', ->
  beforeEach module 'blicblockApp'

  scope = {}
  compile = {}

  beforeEach inject ($controller, $compile, $rootScope) ->
    scope = $rootScope.$new()
    compile = $compile

  it 'is triggered on space keydown', ->
    element = compile('<div ng-space="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keydown')
    e.which = 32
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)

  it 'is triggered on space keypress', ->
    element = compile('<div ng-space="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keypress')
    e.which = 32
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)
