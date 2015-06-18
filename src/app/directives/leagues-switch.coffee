app.directive 'leaguesSwitch', ->
  restrict: 'E'
  templateUrl: 'templates/directives/leagues-switch.html'
  scope:
    leagues: '='
  link: ($scope, $element, $attrs) ->
    $scope.buttonOnClick = (league) ->
      $scope.leagues[league].active = !$scope.leagues[league].active
      return

    $scope.isButtonActive = (league) ->
      $scope.leagues[league].active
    return