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
    default_order = 'value'
    $scope.filters =
      time: $routeParams.time || default_time
      initials: $routeParams.initials || default_initials
      order: $routeParams.order || default_order
      country_code: $routeParams.country_code || default_country_code
      page: $routeParams.page || 1
    $scope.score_results = Score.query($scope.filters)

    $scope.filter = ->
      path = '/scores'
      country_code = $scope.filters.country_code
      if country_code && country_code != default_country_code
        path += "/country/#{country_code}"
      unless $scope.filters.initials == default_initials
        path += "/initials/#{$scope.filters.initials}"
      unless $scope.filters.time == default_time
        path += "/time/#{$scope.filters.time}"
      unless $scope.filters.order == default_order
        path += "/order/#{$scope.filters.order}"
      unless $scope.score_results.page == 1
        path += "/page/#{$scope.score_results.page}"
      $location.path path

    $scope.change_page = ->
      $scope.filters.page = $scope.score_results.page
      $scope.filter()
  ]
