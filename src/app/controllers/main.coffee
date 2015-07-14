app.controller 'MainCtrl', ($scope) ->
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
        matches = _.map _.filter(rawData[index * 2 + 1], 'Team': d.Team), (d) ->
          {
            Opp: d.Opp
            Date: moment(d.Date, dateFormat).toDate()
            GF: parseInt d.GF
            GA: parseInt d.GA
            CF: parseInt d.CF
            CA: parseInt d.CA
          }

        $scope.data.leaguesData[league][d.Team] =
          RUS: d.RUS
          Matches: matches
          Lines: []
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

    # Goals and chances
    d3.csv '../data/premier-league-goals-chances.csv', ((d) ->
      {
        Team: d.Team
        Opp: d.Opp
        Date: moment(d.Date, dateFormat).toDate()
        Type: d.Type
        Player: d.Player
        Timer: d.Timer
        x1: parseFloat d.x1
        y1: parseFloat d.y1
        x2: parseFloat d.x2
        y2: parseFloat d.y2
      }
    ), (error, preparsedData) ->
      _.keys($scope.data.leaguesData['premierLeague']).forEach (key) ->
        lines = _.filter preparsedData, (pD) ->
          (pD.Team is key or pD.Opp is key) and pD.Type

        $scope.data.leaguesData['premierLeague'][key].Lines = lines
        return

      d3.csv '../data/la-liga-goals-chances.csv', ((d) ->
        {
          Team: d.Team
          Opp: d.Opp
          Date: moment(d.Date, dateFormat).toDate()
          Type: d.Type
          Player: d.Player
          Timer: d.Timer
          x1: parseFloat d.x1
          y1: parseFloat d.y1
          x2: parseFloat d.x2
          y2: parseFloat d.y2
        }
      ), (error, preparsedData) ->
        _.keys($scope.data.leaguesData['laLiga']).forEach (key) ->
          lines = _.filter preparsedData, (pD) ->
            (pD.Team is key or pD.Opp is key) and pD.Type

          $scope.data.leaguesData['laLiga'][key].Lines = lines
          return

        $scope.isDataPrepared = true

        $scope.$apply()
        return

      $scope.isDataPrepared = true

      $scope.$apply()
      return
    return

  # Load data
  queue()
  .defer d3.csv, '../data/premier-league-teams.csv'
  .defer d3.csv, '../data/premier-league-results.csv'
  .defer d3.csv, '../data/la-liga-teams.csv'
  .defer d3.csv, '../data/la-liga-results.csv'
  .defer d3.csv, '../data/bundesliga-teams.csv'
  .defer d3.csv, '../data/bundesliga-results.csv'
  .defer d3.csv, '../data/serie-a-teams.csv'
  .defer d3.csv, '../data/serie-a-results.csv'
  .defer d3.csv, '../data/ligue-one-teams.csv'
  .defer d3.csv, '../data/ligue-one-results.csv'
  .awaitAll parseData

  return
