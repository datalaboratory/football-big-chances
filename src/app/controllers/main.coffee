app.controller 'MainCtrl', ($scope) ->
  $scope.leagues =
    premierLeague: active: true
    laLiga: active: false
    bundesliga: active: false
    serieA: active: false
    ligueOne: active: false

  $scope.view = 'field-table'

  $scope.dateFormat = 'DD.MM.YYYY'

  $scope.data = {}

  $scope.isDataPrepared = false

  # Parse data
  parseData = (error, rawData) ->
    if error
      console.log error

    [
      'premierLeague'
      'laLiga'
      'bundesliga'
      'serieA'
      'ligueOne'
    ].forEach (league, index) ->
      $scope.data[league] = {}

      rawData[index * 2].forEach (d) ->
        matches = _.map _.filter(rawData[index * 2 + 1], 'Team': d.Team), (d) ->
          {
            Opp: d.Opp
            Date: moment(d.Date, $scope.dateFormat).toDate()
            GF: parseInt d.GF
            GA: parseInt d.GA
            CF: parseInt d.CF
            CA: parseInt d.CA
          }

        $scope.data[league][d.Team] =
          RUS: d.RUS
          Matches: matches
        return
      return

    $scope.matchDates = []
    $scope.allDates = []
    dates = []
    i = 1

    while i <= rawData.length
      dates = dates.concat _.pluck rawData[i], 'Date'
      i += 2

    $scope.matchDates = _.map(_.uniq(dates), (d) ->
      moment(d, $scope.dateFormat).toDate()
    ).sort (a, b) ->
      a - b

    $scope.startDate = moment($scope.matchDates[0]).subtract(1, 'days').toDate()
    $scope.endDate = $scope.matchDates[$scope.matchDates.length - 1]
       
    moment.range($scope.startDate, $scope.endDate).by 'days', (d) ->
      $scope.allDates.push d.toDate()
      return
    
    $scope.currentDate = moment($scope.matchDates[0]).subtract(1, 'days')

    $scope.isDataPrepared = true
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