'use strict'

describe 'Directive: ngDown', ->
  beforeEach module 'blicblockApp'

  scope = {}
  compile = {}

  beforeEach inject ($controller, $compile, $rootScope) ->
    scope = $rootScope.$new()
    compile = $compile

  it 'is triggered on down arrow keydown', ->
    element = compile('<div ng-down="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keydown')
    e.which = 40
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)

  it 'is triggered on down arrow keypress', ->
    element = compile('<div ng-down="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keypress')
    e.which = 40
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)

  it 'is triggered on letter s keydown', ->
    element = compile('<div ng-down="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keydown')
    e.which = 115
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)

  it 'is triggered on letter s keypress', ->
    element = compile('<div ng-down="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    e = $.Event('keypress')
    e.which = 115
    $(element).trigger(e)
    expect(scope.touched).toEqual(true)
