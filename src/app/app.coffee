appDependencies = [
	'ngRoute'
]

app = angular.module 'app', appDependencies
.config [
	'$routeProvider', '$locationProvider'
	($routeProvider, $locationProvider) ->
		$routeProvider
		.when '/',
			templateUrl: 'templates/pages/main.html'
			controller: 'MainCtrl'
			reloadOnSearch: false
		.otherwise redirectTo: '/'

		$locationProvider.html5Mode enabled: true, requireBase: false
		return
]