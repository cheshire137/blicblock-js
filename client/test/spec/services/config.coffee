'use strict'

describe 'Service: Config', ->
  beforeEach module 'blicblockApp'

  Config = {}
  beforeEach inject ($injector) ->
    Config = $injector.get('Config')

  it 'is defined', ->
    expect(Config).toBeDefined()
