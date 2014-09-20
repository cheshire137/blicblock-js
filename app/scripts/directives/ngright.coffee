'use strict'

###*
 # @ngdoc directive
 # @name blicblockApp.directive:ngRight
 # @description
 # # ngRight
###
angular.module('blicblockApp')
  .directive('ngRight', ->
    (scope, element, attrs) ->
      element.bind 'keydown keypress', (event) ->
        if event.which == 39
          scope.$apply ->
            scope.$eval attrs.ngRight
          event.preventDefault()
  )
