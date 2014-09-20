'use strict'

###*
 # @ngdoc directive
 # @name blicblockApp.directive:ngDown
 # @description
 # # ngDown
###
angular.module('blicblockApp')
  .directive('ngDown', ->
    (scope, element, attrs) ->
      element.bind 'keydown keypress', (event) ->
        if event.which == 40
          scope.$apply ->
            scope.$eval attrs.ngDown
          event.preventDefault()
  )
