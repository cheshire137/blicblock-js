'use strict'

###*
 # @ngdoc service
 # @name blicblockApp.Score
 # @description
 # # Score
 # Factory in the blicblockApp.
###
angular.module('blicblockApp')
  .factory 'Score', ['$resource', ($resource) ->
    $resource '/api/scores/:id.json', {},
      'query':
        method: 'GET'
        isArray: false
      'update':
        method: 'PUT'
  ]
