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
        return unless event.which
        if event.which == 37 || String.fromCharCode(event.which) == 'a'
          scope.$apply ->
            scope.$eval attrs.ngLeft
          event.preventDefault()
  )
