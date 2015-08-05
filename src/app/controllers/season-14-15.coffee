app.controller 'Season1415Ctrl', ($scope) ->
  dateFormat = 'DD.MM.YYYY'

  $scope.leagues = ['premierLeague', 'laLiga', 'bundesliga', 'serieA', 'ligueOne']

  $scope.data =
    activeLeagues:
      premierLeague: true
      laLiga: false
      bundesliga: false
      serieA: false
      ligueOne: false
    currentView: 'field-table'
    dates:
      all: []
      matches: []
      current: undefined
    leaguesData: {}
    sortBy: 'gp'
    sortingOrder: true
    selectedTeam:
      league: 'premierLeague'
      name: 'CHE'
    showOnly: ''

  $scope.isDataPrepared = false

  # Parse data
  parseData = (error, rawData) ->
    if error
      console.log error

    # Leagues and teams data
    $scope.leagues.forEach (league, index) ->
      $scope.data.leaguesData[league] = {}

      rawData[index * 2].forEach (d) ->
        lines = []
        matches = []

        if league is 'premierLeague' or league is 'laLiga'
          lines = _.map _.filter(rawData[index * 2 + 1], (rD) ->
            rD.Team is d.Team or rD.Opp is d.Team
          ), (fD) ->
            {
              Team: fD.Team
              Opp: fD.Opp
              Date: moment(fD.Date, dateFormat).toDate()
              Type: fD.Type
              Player: fD.Player
              Timer: fD.Timer
              x1: parseFloat fD.x1
              y1: parseFloat fD.y1
              x2: parseFloat fD.x2
              y2: parseFloat fD.y2
              unformattedDate: fD.Date
            }

          _.uniq(_.pluck(lines, 'unformattedDate')).forEach (unformattedDate) ->
            matchLines = _.filter lines, (l) -> l.unformattedDate is unformattedDate

            matches.push {
              Opp: _.filter(_.uniq(_.pluck(matchLines, 'Opp')), (u) -> u isnt d.Team)[0]
              Date: moment(unformattedDate, dateFormat).toDate()
              GF: _.filter(matchLines, (mL) -> mL.Team is d.Team and mL.Type.indexOf('G') isnt -1).length
              GA: _.filter(matchLines, (mL) -> mL.Team isnt d.Team and mL.Type.indexOf('G') isnt -1).length
              CF: _.filter(matchLines, (mL) -> mL.Team is d.Team and mL.Type and mL.Type isnt 'GF').length
              CA: _.filter(matchLines, (mL) -> mL.Team isnt d.Team and mL.Type and mL.Type isnt 'GF').length
            }

            lines = _.filter lines, (l) -> l.Type
        else
          matches = _.map _.filter(rawData[index * 2 + 1], 'Team': d.Team), (fD) ->
            {
              Opp: fD.Opp
              Date: moment(fD.Date, dateFormat).toDate()
              GF: parseInt fD.GF
              GA: parseInt fD.GA
              CF: parseInt fD.CF
              CA: parseInt fD.CA
              unformattedDate: fD.Date
            }

        $scope.data.leaguesData[league][d.Team] =
          RUS: d.RUS
          Matches: matches
          Lines: lines
        return
      return

    # Dates
    dates = []
    i = 1

    while i <= rawData.length
      dates = dates.concat _.pluck rawData[i], 'Date'
      i += 2

    $scope.data.dates.matches = _.map(_.uniq(dates), (d) ->
      moment(d, dateFormat).toDate()
    ).sort (a, b) ->
      a - b

    startDate = moment($scope.data.dates.matches[0]).subtract(1, 'days').toDate()

    moment.range(startDate, $scope.data.dates.matches[$scope.data.dates.matches.length - 1]).by 'days', (d) ->
      $scope.data.dates.all.push d.toDate()

    $scope.data.dates.current = $scope.data.dates.matches[$scope.data.dates.matches.length - 1]

    $scope.isDataPrepared = true

    $scope.$apply()
    return

  # Load data
  queue()
  .defer d3.csv, '../data/premier-league-teams.csv'
  .defer d3.csv, '../data/premier-league-goals-chances.csv'
  .defer d3.csv, '../data/la-liga-teams.csv'
  .defer d3.csv, '../data/la-liga-goals-chances.csv'
  .defer d3.csv, '../data/bundesliga-teams.csv'
  .defer d3.csv, '../data/bundesliga-results.csv'
  .defer d3.csv, '../data/serie-a-teams.csv'
  .defer d3.csv, '../data/serie-a-results.csv'
  .defer d3.csv, '../data/ligue-one-teams.csv'
  .defer d3.csv, '../data/ligue-one-results.csv'
  .awaitAll parseData

  return
