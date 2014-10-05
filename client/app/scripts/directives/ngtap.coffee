'use strict'

###*
 # @ngdoc directive
 # @name blicblockApp.directive:ngTap
 # @description
 # # ngTap
###
angular.module('blicblockApp')
  .directive('ngTap', ->
    link: (scope, element, attrs) ->
      tapping = false
      element.bind 'touchstart', (e) ->
        element.addClass('active')
        tapping = true
        true
      element.bind 'touchmove', (e) ->
        element.removeClass('active')
        tapping = false
        true
      element.bind 'touchend', (e) ->
        element.removeClass('active')
        scope.$apply(attrs['ngTap'], element) if tapping
        true
  )
