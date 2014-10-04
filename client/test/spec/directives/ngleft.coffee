'use strict'

describe 'Directive: ngLeft', ->
  beforeEach module 'blicblockApp'

  scope = {}
  compile = {}

  beforeEach inject ($controller, $compile, $rootScope) ->
    scope = $rootScope.$new()
    compile = $compile

  it 'is triggered on left arrow keydown', ->
    element = compile('<div ng-left="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keydown')
    e.which = 37
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)

  it 'is triggered on left arrow keypress', ->
    element = compile('<div ng-left="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keypress')
    e.which = 37
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)

  it 'is triggered on letter a keydown', ->
    element = compile('<div ng-left="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keydown')
    e.which = 97
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)

  it 'is triggered on letter a keypress', ->
    element = compile('<div ng-left="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keypress')
    e.which = 97
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)
