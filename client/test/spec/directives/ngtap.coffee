'use strict'

describe 'Directive: ngTap', ->
  beforeEach module 'blicblockApp'

  scope = {}
  compile = {}

  beforeEach inject ($controller, $compile, $rootScope) ->
    scope = $rootScope.$new()
    compile = $compile

  it 'is triggered on body tap', ->
    element = compile('<div ng-tap="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    $(element).trigger($.Event('touchstart'))
    $(element).trigger($.Event('touchend'))
    expect(scope.touched).toEqual(true)

  it 'is not triggered on body drag', ->
    element = compile('<div ng-tap="touched = true"></div>')(scope)
    expect(scope.touched).toBeFalsy()
    $(element).trigger($.Event('touchstart'))
    $(element).trigger($.Event('touchmove'))
    $(element).trigger($.Event('touchend'))
    expect(scope.touched).toBeFalsy()
