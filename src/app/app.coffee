appDependencies = [
  'ngRoute'
]

app = angular.module 'app', appDependencies
.config [
  '$routeProvider', '$locationProvider'
  ($routeProvider, $locationProvider) ->
    $routeProvider
    .when '/14-15',
      templateUrl: 'templates/pages/season-14-15.html'
      controller: 'Season1415Ctrl'
    .otherwise redirectTo: '/14-15'

    $locationProvider.html5Mode enabled: true, requireBase: false
    return
]
