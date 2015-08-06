app.directive 'leagueTable', ->
  restrict: 'E'
  templateUrl: 'templates/directives/league-table.html'
  scope:
    league: '='
    leagueData: '='
    leftDate: '='
    rightDate: '='
    sortBy: '='
    sortingOrder: '='
    selectedTeam: '='
  link: ($scope, $element, $attrs) ->
    $scope.teamValues = {}

    _.keys($scope.leagueData).forEach (key) ->
      $scope.teamValues[key] = {}

    updateTeamValues = ->
      _.keys($scope.teamValues).forEach (key) ->
        matches = _.filter $scope.leagueData[key].Matches, (M) ->
          moment($scope.leftDate).diff(M.Date, 'days') <= 0 and moment($scope.rightDate).diff(M.Date, 'days') >= 0

        noChancesData = _.filter(_.pluck(matches, 'CF'), (d) -> isNaN(d)).length or _.filter(_.pluck(matches, 'CA'), (d) -> isNaN(d)).length

        values = {
          GF: _.sum matches, 'GF'
          GA: _.sum matches, 'GA'
          CF: unless noChancesData then _.sum matches, 'CF' else -1
          CA: unless noChancesData then _.sum matches, 'CA' else -1
          M: matches.length
          GW: _.filter(matches, (m) -> m.GF > m.GA).length
          GD: _.filter(matches, (m) -> m.GF is m.GA).length
          GL: _.filter(matches, (m) -> m.GF < m.GA).length
          CW: unless noChancesData then _.filter(matches, (m) -> m.CF > m.CA).length else -1
          CD: unless noChancesData then _.filter(matches, (m) -> m.CF is m.CA).length else -1
          CL: unless noChancesData then _.filter(matches, (m) -> m.CF < m.CA).length else -1
        }

        values.CP = values.CW * 3 + values.CD
        values.GP = values.GW * 3 + values.GD

        $scope.teamValues[key] = values
      return

    $scope.$watch 'leftDate', -> updateTeamValues()

    $scope.$watch 'rightDate', -> updateTeamValues()

    $scope.getGF = (obj) ->
      $scope.teamValues[obj.$key].GF

    $scope.getGA = (obj) ->
      $scope.teamValues[obj.$key].GA

    $scope.getGDiff = (obj) ->
      $scope.teamValues[obj.$key].GF - $scope.teamValues[obj.$key].GA

    $scope.getCF = (obj) ->
      $scope.teamValues[obj.$key].CF

    $scope.getCA = (obj) ->
      $scope.teamValues[obj.$key].CA

    $scope.getCDiff = (obj) ->
      $scope.teamValues[obj.$key].CF - $scope.teamValues[obj.$key].CA

    $scope.getGW = (obj) ->
      $scope.teamValues[obj.$key].GW

    $scope.getGP = (obj) ->
      $scope.teamValues[obj.$key].GP

    $scope.getCW = (obj) ->
      $scope.teamValues[obj.$key].CW

    $scope.getCP = (obj) ->
      $scope.teamValues[obj.$key].CP

    $scope.rowOnClick = (team, league) ->
      if league is $scope.selectedTeam.league and team is $scope.selectedTeam.name
        $scope.selectedTeam.league = ''
        $scope.selectedTeam.name = ''
      else
        $scope.selectedTeam.league = league
        $scope.selectedTeam.name = team
      return

    return
