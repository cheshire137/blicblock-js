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
    $scope.all_countries = Country.query()
    default_time = 'week'
    default_initials = ''
    default_country_codes = ''
    default_order = 'value'
    default_view = 'table'
    $scope.settings =
      view: $routeParams.view || default_view
    $scope.country_options = []
    $scope.filters =
      time: $routeParams.time || default_time
      initials: $routeParams.initials || default_initials
      order: $routeParams.order || default_order
      country_codes: $routeParams.country_codes || default_country_codes
      page: $routeParams.page || 1
    $scope.score_results = Score.query($scope.filters)
    $scope.countries = Country.query($scope.filters)

    $scope.$watch 'all_countries.length', ->
      return if $scope.all_countries.length < 1
      selected_codes = $scope.filters.country_codes.split(',')
      $scope.country_options = ({name: c.name, code: c.code, selected: selected_codes.indexOf(c.code) > -1} for c in $scope.all_countries)

    $scope.filter = ->
      path = '/scores'
      country_codes = (c.code for c in $scope.country_options when c.selected).join(',')
      unless country_codes == default_country_codes
        path += "/countries/#{country_codes}"
      unless $scope.filters.initials == default_initials
        path += "/initials/#{$scope.filters.initials}"
      unless $scope.filters.time == default_time
        path += "/time/#{$scope.filters.time}"
      unless $scope.filters.order == default_order
        path += "/order/#{$scope.filters.order}"
      unless $scope.filters.page == 1
        path += "/page/#{$scope.filters.page}"
      unless $scope.settings.view == default_view
        path += "/view/#{$scope.settings.view}"
      $location.path path

    $scope.change_page = ->
      $scope.filters.page = $scope.score_results.page
      $scope.filter()
  ]
