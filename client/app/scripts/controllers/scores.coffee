'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:ScoresCtrl
 # @description
 # # ScoresCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'ScoresCtrl', ['$scope', '$location', '$routeParams', 'Score', 'Country', ($scope, $location, $routeParams, Score, Country) ->
    $scope.countries = Country.query()
    default_time = 'week'
    default_initials = ''
    default_country_code = ''
    $scope.filters =
      time: $routeParams.time || default_time
      initials: $routeParams.initials || default_initials
      order: 'value'
      country_code: $routeParams.country_code || default_country_code
    $scope.score_results = Score.query($scope.filters)

    $scope.filter = ->
      path = '/scores'
      unless $scope.filters.country_code == default_country_code
        path += "/country/#{$scope.filters.country_code}"
      unless $scope.filters.initials == default_initials
        path += "/initials/#{$scope.filters.initials}"
      unless $scope.filters.time == default_time
        path += "/time/#{$scope.filters.time}"
      $location.path path

    $scope.change_page = ->
      params = {}
      for key, value of $scope.filters
        params[key] = value
      params.page = $scope.score_results.page
      $scope.score_results = Score.query(params)
  ]
