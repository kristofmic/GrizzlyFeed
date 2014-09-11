var GrizzlyFeedApp = angular.module('GrizzlyFeedApp', ['ngRoute', 'ui.sortable', 'ngSanitize']);

GrizzlyFeedApp.config(['$routeProvider',
  function($routeProvider){
    $routeProvider.
      when('/home', {
        templateUrl: '/home', 
        controller: 'HomeCtrl'
      }).
      when('/policies', {
        templateUrl: '/policies',
        controller: 'PoliciesCtrl'
      }).
      when('/about', {
        templateUrl: '/about'
      }).
      when('/support', {
        templateUrl: '/support'
      }).
      when('/feeds', {
        templateUrl: '/feeds',
        controller: 'FeedsCtrl'
      }).
      when('/feeds/new', {
        templateUrl: '/feeds/new',
        controller: 'FeedsNewCtrl'
      }).
      when('/profile', {
        templateUrl: '/profile',
        controller: 'UserCtrl'
      }).
      otherwise({
        redirectTo: '/home'
      })
  }]);

