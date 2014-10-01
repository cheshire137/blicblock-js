'use strict'

###*
 # @ngdoc service
 # @name blicblockApp.Config
 # @description
 # # Config
 # Service in the blicblockApp.
###
angular.module('blicblockApp')
  .service 'Config', ->
    class Config
      constructor: ->
        @storage_keys =
          high_score: 'high_score'

    new Config()
