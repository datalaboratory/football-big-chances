app.directive 'leagueTable', ->
  restrict: 'E'
  templateUrl: 'templates/directives/league-table.html'
  scope:
    league: '='
    leagueData: '='
    currentDate: '='
    sortBy: '='
    sortingOrder: '='
    selectedTeam: '='
  link: ($scope, $element, $attrs) ->
    $scope.teamValues = {}

    _.keys($scope.leagueData).forEach (key) ->
      $scope.teamValues[key] = {}

    $scope.$watch 'currentDate', ->
      _.keys($scope.teamValues).forEach (key) ->
        matches = _.filter $scope.leagueData[key].Matches, (M) ->
          moment($scope.currentDate).diff(M.Date, 'days') >= 0
        values = {
          cf: if $scope.league is 'premierLeague' or $scope.league is 'laLiga' then _.sum matches, 'CF' else -1
          gf: _.sum matches, 'GF'
          ca: if $scope.league is 'premierLeague' or $scope.league is 'laLiga' then _.sum matches, 'CA' else -1
          ga: _.sum matches, 'GA'
          m: matches.length
          gw: _.filter(matches, (m) -> m.GF > m.GA).length
          gd: _.filter(matches, (m) -> m.GF is m.GA).length
          gl: _.filter(matches, (m) -> m.GF < m.GA).length
          cw: if $scope.league is 'premierLeague' or $scope.league is 'laLiga' then  _.filter(matches, (m) -> m.CF > m.CA).length else -1
          cd: if $scope.league is 'premierLeague' or $scope.league is 'laLiga' then  _.filter(matches, (m) -> m.CF is m.CA).length else -1
          cl: if $scope.league is 'premierLeague' or $scope.league is 'laLiga' then  _.filter(matches, (m) -> m.CF < m.CA).length else -1
        }

        values.cp = values.cw * 3 + values.cd
        values.gp = values.gw * 3 + values.gd

        $scope.teamValues[key] = values
      return

    $scope.getGF = (obj) ->
      $scope.teamValues[obj.$key].gf

    $scope.getGA = (obj) ->
      $scope.teamValues[obj.$key].ga

    $scope.getGDiff = (obj) ->
      $scope.teamValues[obj.$key].gf - $scope.teamValues[obj.$key].ga

    $scope.getCF = (obj) ->
      $scope.teamValues[obj.$key].cf

    $scope.getCA = (obj) ->
      $scope.teamValues[obj.$key].ca

    $scope.getCDiff = (obj) ->
      $scope.teamValues[obj.$key].cf - $scope.teamValues[obj.$key].ca

    $scope.getGW = (obj) ->
      $scope.teamValues[obj.$key].gw

    $scope.getGP = (obj) ->
      $scope.teamValues[obj.$key].gp

    $scope.getCW = (obj) ->
      $scope.teamValues[obj.$key].cw

    $scope.getCP = (obj) ->
      $scope.teamValues[obj.$key].cp

    $scope.rowOnClick = (team, league) ->
      if league is $scope.selectedTeam.league and team is $scope.selectedTeam.name
        $scope.selectedTeam.league = ''
        $scope.selectedTeam.name = ''
      else
        $scope.selectedTeam.league = league
        $scope.selectedTeam.name = team
      return

    return
