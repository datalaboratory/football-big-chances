app.directive 'leaguesSwitch', ->
  restrict: 'E'
  templateUrl: 'templates/directives/leagues-switch.html'
  scope:
    leagues: '='
    season: '='
  link: ($scope, $element, $attrs) ->
    $scope.buttonOnClick = (league) ->
      unless $scope.leagues[league] and _.compact(_.values($scope.leagues)).length is 1
        $scope.leagues[league] = !$scope.leagues[league]
      return

    $scope.isButtonActive = (league) ->
      $scope.leagues[league]

    return
