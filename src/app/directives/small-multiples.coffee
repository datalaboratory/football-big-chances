app.directive 'smallMultiples', ->
  restrict: 'E'
  templateUrl: 'templates/directives/small-multiples.html'
  scope:
    activeLeagues: '='
    leaguesData: '='
    currentDate: '='
    shownTypes: '='
  link: ($scope, $element, $attrs) ->
    $scope.getPoints = (obj) ->
      gw = _.filter(obj.Matches, (M) -> M.GF > M.GA).length
      gd = _.filter(obj.Matches, (M) -> M.GF is M.GA).length

      gw * 3 + gd

    return
