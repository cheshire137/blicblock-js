'use strict'

###*
 # @ngdoc function
 # @name blicblockApp.controller:ScoresCtrl
 # @description
 # # ScoresCtrl
 # Controller of the blicblockApp
###
angular.module('blicblockApp')
  .controller 'ScoresCtrl', ['$scope', 'Score', ($scope, Score) ->
    $scope.filters =
      time: 'week'
      initials: ''
      order: 'value'
    $scope.score_results =
      scores: []
      page: 1
      total_pages: 1
      total_records: 1

    $scope.filter = ->
      $scope.score_results = Score.query($scope.filters)

    $scope.change_page = ->
      params = {}
      for key, value of $scope.filters
        params[key] = value
      params.page = $scope.score_results.page
      $scope.score_results = Score.query(params)

    $scope.filter()
  ]
