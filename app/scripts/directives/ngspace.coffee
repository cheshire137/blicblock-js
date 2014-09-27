'use strict'

###*
 # @ngdoc directive
 # @name blicblockApp.directive:ngSpace
 # @description
 # # ngSpace
###
angular.module('blicblockApp')
  .directive('ngSpace', ->
    (scope, element, attrs) ->
      element.bind 'keydown keypress', (event) ->
        return unless event.which
        if event.which == 32
          scope.$apply ->
            scope.$eval attrs.ngSpace
          event.preventDefault()
  )
