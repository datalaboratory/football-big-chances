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

  $scope.isDataPrepared = false

  # Parse data
  parseData = (error, rawData) ->
    if error
      console.log error

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
        return
      return

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

    $scope.data.dates.current = startDate

    $scope.isDataPrepared = true

    $scope.$apply()
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
