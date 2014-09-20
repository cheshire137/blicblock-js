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
        return unless event.which
        if event.which == 40 || String.fromCharCode(event.which) == 's'
          scope.$apply ->
            scope.$eval attrs.ngDown
          event.preventDefault()
  )
