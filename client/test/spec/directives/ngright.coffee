'use strict'

describe 'Directive: ngRight', ->
  beforeEach module 'blicblockApp'

  scope = {}
  compile = {}

  beforeEach inject ($controller, $compile, $rootScope) ->
    scope = $rootScope.$new()
    compile = $compile

  it 'is triggered on right arrow keydown', ->
    element = compile('<div ng-right="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keydown')
    e.which = 39
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)

  it 'is triggered on right arrow keypress', ->
    element = compile('<div ng-right="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keypress')
    e.which = 39
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)

  it 'is triggered on letter d keydown', ->
    element = compile('<div ng-right="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keydown')
    e.which = 100
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)

  it 'is triggered on letter d keypress', ->
    element = compile('<div ng-right="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keypress')
    e.which = 100
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)
