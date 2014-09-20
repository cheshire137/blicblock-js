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
        return unless event.which
        if event.which == 39 || String.fromCharCode(event.which) == 'd'
          scope.$apply ->
            scope.$eval attrs.ngRight
          event.preventDefault()
  )
