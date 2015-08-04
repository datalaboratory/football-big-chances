appDependencies = [
  'ngRoute'
]

app = angular.module 'app', appDependencies
.config [
  '$routeProvider', '$locationProvider'
  ($routeProvider, $locationProvider) ->
    $routeProvider
    .when '/',
      templateUrl: '/templates/pages/main.html'
      controller: 'MainCtrl'
    .otherwise redirectTo: '/'
    return
]
