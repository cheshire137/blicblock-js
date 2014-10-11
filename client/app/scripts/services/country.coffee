'use strict'

###*
 # @ngdoc service
 # @name blicblockApp.country
 # @description
 # # country
 # Service in the blicblockApp.
###
angular.module('blicblockApp')
  .factory 'Country', ['$resource', ($resource) ->
    $resource '/api/scores/countries.json', {}, {}
  ]
