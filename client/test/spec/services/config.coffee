'use strict'

describe 'Service: config', ->

  # load the service's module
  beforeEach module 'blicblockApp'

  # instantiate service
  config = {}
  beforeEach inject (_config_) ->
    config = _config_

  it 'should do something', ->
    expect(!!config).toBe true
