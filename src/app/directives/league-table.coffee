app.directive 'leagueTable', ->
  restrict: 'E'
  templateUrl: 'templates/directives/league-table.html'
  scope:
    league: '='
    leagueData: '='
    currentDate: '='
  link: ($scope, $element, $attrs) ->
    $scope.teamValues = {}

    _.keys($scope.leagueData).forEach (key) ->
      $scope.teamValues[key] = {}

    $scope.$watch 'currentDate', ->
      _.keys($scope.teamValues).forEach (key) ->
        matches = _.filter $scope.leagueData[key].Matches, (M) ->
          moment($scope.currentDate).diff(M.Date, 'days') >= 0
        values = {
          cf: _.sum matches, 'CF'
          gf: _.sum matches, 'GF'
          ca: _.sum matches, 'CA'
          ga: _.sum matches, 'GA'
          m: matches.length
          wg: _.filter(matches, (m) -> m.GF > m.GA).length
          dg: _.filter(matches, (m) -> m.GF is m.GA).length
          lg: _.filter(matches, (m) -> m.GF < m.GA).length
          wc: _.filter(matches, (m) -> m.CF > m.CA).length
          dc: _.filter(matches, (m) -> m.CF is m.CA).length
          lc: _.filter(matches, (m) -> m.CF < m.CA).length
        }

        values.pc = values.wc * 3 + values.dc
        values.pg = values.wg * 3 + values.dg

        $scope.teamValues[key] = values
      return

    return
