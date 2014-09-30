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
      last_event = undefined
      element.bind 'keydown keypress', (event) ->
        return unless event.which
        return if last_event && last_event.which == event.which
        last_event = event
        if event.which == 39 || String.fromCharCode(event.which) == 'd'
          scope.$apply ->
            scope.$eval attrs.ngRight
          event.preventDefault()
      element.bind 'keyup', (event) ->
        last_event = undefined
  )
