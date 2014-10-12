'use strict'

###*
 # @ngdoc directive
 # @name blicblockApp.directive:vectorMap
 # @description
 # # vectorMap
###
angular.module('blicblockApp')
  .directive('vectorMap', ->
    restrict: 'A'
    scope:
      countries: '='
    link:
      (scope, element, attrs) ->
        scope.$watch 'countries.length', ->
          return if scope.countries.length < 1
          country_values = {}
          for country in scope.countries
            country_values[country.code.toUpperCase()] = country.total_scores
          $(element).vectorMap
            map: 'world_mill_en',
            series:
              regions: [
                values: country_values
                scale: ['#C8EEFF', '#0071A4']
                normalizeFunction: 'polynomial'
              ]
            onRegionLabelShow: (e, el, code) ->
              total_scores = country_values[code]
              if total_scores
                units = 'score'
                units += 's' unless total_scores == 1
                el.html(el.html() + ' - ' + total_scores + ' ' + units)
  )
