appDependencies = [
  'ngRoute'
]

app = angular.module 'app', appDependencies
.config [
  '$routeProvider', '$locationProvider'
  ($routeProvider, $locationProvider) ->
    $routeProvider
    .when '/2014-2015',
      templateUrl: 'templates/pages/season-14-15.html'
      controller: 'Season1415Ctrl'
    .when '/2015-2016',
      templateUrl: 'templates/pages/season-15-16.html'
      controller: 'Season1516Ctrl'
    .otherwise redirectTo: '/2015-2016'
    return
]
