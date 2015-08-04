appDependencies = [
  'ngRoute'
]

app = angular.module 'app', appDependencies
.config [
  '$routeProvider', '$locationProvider'
  ($routeProvider, $locationProvider) ->
    $routeProvider
    .when '/14-15',
      templateUrl: '/templates/pages/season-14-15.html'
      controller: 'Season1415Ctrl'
    .when '/15-16',
      templateUrl: '/templates/pages/season-15-16.html'
      controller: 'Season1616Ctrl'
    .otherwise redirectTo: '/14-15'
    return
]
