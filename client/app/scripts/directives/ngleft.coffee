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
      last_event = undefined
      element.bind 'keydown keypress', (event) ->
        return if $(event.target).is('input')
        return unless event.which
        return if last_event && last_event.which == event.which
        last_event = event
        if event.which == 37 || String.fromCharCode(event.which) == 'a'
          scope.$apply ->
            scope.$eval attrs.ngLeft
          event.preventDefault()
      element.bind 'keyup', (event) ->
        last_event = undefined
  )
