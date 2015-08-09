app.directive 'smallMultiples', ->
  restrict: 'E'
  templateUrl: 'templates/directives/small-multiples.html'
  scope:
    activeLeagues: '='
    leaguesData: '='
    leftDate: '='
    rightDate: '='
    shownTypes: '='
    season: '='
  link: ($scope, $element, $attrs) ->
    $scope.getPoints = (obj) ->
      GW = _.filter(obj.Matches, (M) -> M.GF > M.GA).length
      GD = _.filter(obj.Matches, (M) -> M.GF is M.GA).length

      GW * 3 + GD

    return
