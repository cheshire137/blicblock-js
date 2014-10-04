'use strict'

###*
 # @ngdoc overview
 # @name blicblockApp
 # @description
 # # blicblockApp
 #
 # Main module of the application.
###
angular
  .module('blicblockApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'ui.bootstrap',
    'LocalStorageModule',
    'angularMoment'
  ])
  .config(['$routeProvider', 'localStorageServiceProvider', ($routeProvider, localStorageServiceProvider) ->
    localStorageServiceProvider.setPrefix('blicblockJS')
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/test/:color_count',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
      .when '/scores',
        templateUrl: 'views/scores.html'
        controller: 'ScoresCtrl'
      .otherwise
        redirectTo: '/'
  ])
  .filter 'reverse', ->
    (items) -> items.slice().reverse()
