'use strict'

###*
 # @ngdoc service
 # @name blicblockApp.aichoice
 # @description
 # # aichoice
 # Service in the blicblockApp.
###

angular.module('blicblockApp')
  .service 'AiChoice', ['$rootScope', '$interval', '$timeout', ($rootScope, $interval, $timeout) ->
    class AI
      constructor: ->

