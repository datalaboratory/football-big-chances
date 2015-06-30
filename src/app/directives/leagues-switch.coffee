app.directive 'leaguesSwitch', ->
  restrict: 'E'
  templateUrl: 'templates/directives/leagues-switch.html'
  scope:
    leagues: '='
  link: ($scope, $element, $attrs) ->
    $scope.buttonOnClick = (league) ->
      $scope.leagues[league] = !$scope.leagues[league]
      return

    $scope.isButtonActive = (league) ->
      $scope.leagues[league]

    return
