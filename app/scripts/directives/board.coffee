'use strict'

###*
 # @ngdoc directive
 # @name blicblockApp.directive:board
 # @description
 # # board
###
angular.module('blicblockApp')
  .directive('board', ->
    template: '<div></div>'
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.addClass 'board'
  )
