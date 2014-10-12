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
    'ngAnimate'
    'ngCookies'
    'ngResource'
    'ngRoute'
    'ngSanitize'
    'ngTouch'
    'ui.bootstrap'
    'LocalStorageModule'
    'angularMoment'
    'swipe'
    'multi-select'
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
    score_opts =
      templateUrl: 'views/scores.html'
      controller: 'ScoresCtrl'
      title: 'High Scores'
    $routeProvider.when '/scores', score_opts
                  .when '/scores/countries/:country_codes', score_opts
                  .when '/scores/initials/:initials', score_opts
                  .when '/scores/time/:time', score_opts
                  .when '/scores/order/:order', score_opts
                  .when '/scores/page/:page', score_opts
                  .when '/scores/countries/:country_codes/view/:view', score_opts
                  .when '/scores/initials/:initials/view/:view', score_opts
                  .when '/scores/time/:time/view/:view', score_opts
                  .when '/scores/order/:order/view/:view', score_opts
                  .when '/scores/page/:page/view/:view', score_opts
                  .when '/scores/countries/:country_codes/page/:page', score_opts
                  .when '/scores/initials/:initials/page/:page', score_opts
                  .when '/scores/time/:time/page/:page', score_opts
                  .when '/scores/order/:order/page/:page', score_opts
                  .when '/scores/countries/:country_codes/order/:order', score_opts
                  .when '/scores/countries/:country_codes/order/:order/page/:page', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/page/:page', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/order/:order', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/order/:order/page/:page', score_opts
                  .when '/scores/countries/:country_codes/time/:time', score_opts
                  .when '/scores/countries/:country_codes/time/:time/page/:page', score_opts
                  .when '/scores/countries/:country_codes/time/:time/order/:order', score_opts
                  .when '/scores/countries/:country_codes/time/:time/order/:order/page/:page', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/time/:time', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/time/:time/page/:page', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/time/:time/order/:order', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/time/:time/order/:order/page/:page', score_opts
                  .when '/scores/initials/:initials/order/:order', score_opts
                  .when '/scores/initials/:initials/order/:order/page/:page', score_opts
                  .when '/scores/initials/:initials/time/:time', score_opts
                  .when '/scores/initials/:initials/time/:time/page/:page', score_opts
                  .when '/scores/initials/:initials/time/:time/order/:order', score_opts
                  .when '/scores/initials/:initials/time/:time/order/:order/page/:page', score_opts
                  .when '/scores/time/:time/order/:order', score_opts
                  .when '/scores/time/:time/order/:order/page/:page', score_opts
                  .when '/scores/countries/:country_codes/page/:page/view/:view', score_opts
                  .when '/scores/initials/:initials/page/:page/view/:view', score_opts
                  .when '/scores/time/:time/page/:page/view/:view', score_opts
                  .when '/scores/order/:order/page/:page/view/:view', score_opts
                  .when '/scores/countries/:country_codes/order/:order/view/:view', score_opts
                  .when '/scores/countries/:country_codes/order/:order/page/:page/view/:view', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/view/:view', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/page/:page/view/:view', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/order/:order/view/:view', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/order/:order/page/:page/view/:view', score_opts
                  .when '/scores/countries/:country_codes/time/:time/view/:view', score_opts
                  .when '/scores/countries/:country_codes/time/:time/page/:page/view/:view', score_opts
                  .when '/scores/countries/:country_codes/time/:time/order/:order/view/:view', score_opts
                  .when '/scores/countries/:country_codes/time/:time/order/:order/page/:page/view/:view', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/time/:time/view/:view', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/time/:time/page/:page/view/:view', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/time/:time/order/:order/view/:view', score_opts
                  .when '/scores/countries/:country_codes/initials/:initials/time/:time/order/:order/page/:page/view/:view', score_opts
                  .when '/scores/initials/:initials/order/:order/view/:view', score_opts
                  .when '/scores/initials/:initials/order/:order/page/:page/view/:view', score_opts
                  .when '/scores/initials/:initials/time/:time/view/:view', score_opts
                  .when '/scores/initials/:initials/time/:time/page/:page/view/:view', score_opts
                  .when '/scores/initials/:initials/time/:time/order/:order/view/:view', score_opts
                  .when '/scores/initials/:initials/time/:time/order/:order/page/:page/view/:view', score_opts
                  .when '/scores/time/:time/order/:order/view/:view', score_opts
                  .when '/scores/time/:time/order/:order/page/:page/view/:view', score_opts
    $routeProvider.otherwise redirectTo: '/'
  ])
  .filter('reverse', ->
    (items) -> items.slice().reverse()
  ).filter('range', ->
    (input, total) ->
      total = parseInt(total, 10)
      for i in [0...total]
        input.push i
      input
  ).run ['$location', '$rootScope', ($location, $rootScope) ->
    $rootScope.$on '$routeChangeSuccess', (event, current, previous) ->
      if current.hasOwnProperty('$$route')
        $rootScope.collapse.nav = true
        $rootScope.title = current.$$route.title
  ]
