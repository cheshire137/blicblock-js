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
    'angularMoment',
    'swipe',
    'ngResize'
  ])
  .config(['$routeProvider', 'localStorageServiceProvider', ($routeProvider, localStorageServiceProvider) ->
    localStorageServiceProvider.setPrefix('blicblockJS')
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        title: 'Play'
      .when '/test/:color_count',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        title: 'Test'
      .when '/test/cascade/:cascade_count',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        title: 'Test Cascades'
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
        title: 'About'
      .when '/help',
        templateUrl: 'views/help.html'
        controller: 'AboutCtrl'
        title: 'How to Play'
      .when '/scores',
        templateUrl: 'views/scores.html'
        controller: 'ScoresCtrl'
        title: 'High Scores'
      .otherwise
        redirectTo: '/'
  ])
  .filter('reverse', ->
    (items) -> items.slice().reverse()
  ).run ['$location', '$rootScope', ($location, $rootScope) ->
    $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->
      if current.hasOwnProperty('$$route')
        $rootScope.title = current.$$route.title
  ]
