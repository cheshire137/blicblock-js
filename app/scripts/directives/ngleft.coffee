'use strict'

###*
 # @ngdoc directive
 # @name blicblockApp.directive:ngLeft
 # @description
 # # ngLeft
###
angular.module('blicblockApp')
  .directive('ngLeft', ->
    (scope, element, attrs) ->
      element.bind 'keydown keypress', (event) ->
        if event.which == 37
          scope.$apply ->
            scope.$eval attrs.ngLeft
          event.preventDefault()
  )
