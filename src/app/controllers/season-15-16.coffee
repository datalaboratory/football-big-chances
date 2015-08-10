app.controller 'Season1516Ctrl', ($scope) ->
  $scope.seasonActive = '2015-2016'

  $scope.seasons = ['2014-2015', '2015-2016']

  $scope.leagues = ['premierLeague', 'laLiga', 'bundesliga', 'serieA', 'ligueOne', 'rfpl']

  $scope.monthNames = [
    ['янв', 'янв'],
    ['фев', 'фев'],
    ['мар', 'мар'],
    ['апр', 'апр'],
    ['май', 'мая'],
    ['июнь', 'июня'],
    ['июль', 'июля'],
    ['авг', 'авг'],
    ['сен', 'сен'],
    ['окт', 'окт'],
    ['ноя', 'ноя'],
    ['дек', 'дек']
  ]

  $scope.allDates = []
  $scope.matchDates = []

  $scope.leaguesData = {}

  $scope.model =
    activeLeagues:
      premierLeague: false
      laLiga: false
      bundesliga: false
      serieA: false
      ligueOne: false
      rfpl: true
    currentView: 'field-table'
    leftDate: undefined
    rightDate: undefined
    sortBy: 'GP'
    sortingOrder: true
    selectedTeam:
      league: 'rfpl'
      name: 'ZEN'
    shownTypes: ['G', 'CG', 'CO', 'CB', 'CS']

  $scope.isDataPrepared = false

  # Parse data
  parseData = (error, rawData) ->
    if error
      console.log error

    dateFormat = 'DD.MM.YYYY'

    # Leagues and teams data
    $scope.leagues.forEach (league, index) ->
      $scope.leaguesData[league] = {}

      rawData[index * 2].forEach (d) ->
        lines = []
        matches = []

        unless league is 'rfpl'
          lines = _.map _.filter(rawData[index * 2 + 1], (rD) -> rD.Team is d.Team or rD.Opp is d.Team), (fD) ->
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
              CF: _.filter(matchLines, (mL) -> mL.Team is d.Team and mL.Type and mL.Type isnt 'G').length
              CA: _.filter(matchLines, (mL) -> mL.Team isnt d.Team and mL.Type and mL.Type isnt 'G').length
            }

            lines = _.filter lines, (l) -> l.Type
        else
          matches = _.map _.filter(rawData[index * 2 + 1], (rD) -> rD.Team is d.Team or rD.Opp is d.Team), (fD) ->
            isTeamOpp = fD.Team isnt d.Team

            {
              Opp: if isTeamOpp then fD.Team else fD.Opp
              Date: moment(fD.Date, dateFormat).toDate()
              GF: parseInt if isTeamOpp then fD.GO else fD.GT
              GA: parseInt if isTeamOpp then fD.GT else fD.GO
              CF: parseInt if isTeamOpp then fD.CO else fD.CT
              CA: parseInt if isTeamOpp then fD.CT else fD.CO
              unformattedDate: fD.Date
            }

        $scope.leaguesData[league][d.Team] =
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

    $scope.matchDates = _.map(_.uniq(dates), (d) ->
      moment(d, dateFormat).toDate()
    ).sort (a, b) ->
      a - b

    startDate = moment($scope.matchDates[0]).subtract(1, 'days').toDate()

    moment.range(startDate, $scope.matchDates[$scope.matchDates.length - 1]).by 'days', (d) ->
      $scope.allDates.push d.toDate()

    $scope.model.rightDate = if moment().toDate() > $scope.matchDates[$scope.matchDates.length - 1] then $scope.matchDates[$scope.matchDates.length - 1] else moment().toDate()
    $scope.model.leftDate = $scope.allDates[0]

    $scope.isDataPrepared = true

    $scope.$apply()
    return

  # Load data
  queue()
  .defer d3.csv, '../data/2015-2016/premier-league-teams.csv'
  .defer d3.csv, '../data/2015-2016/premier-league-goals-chances.csv'
  .defer d3.csv, '../data/2015-2016/la-liga-teams.csv'
  .defer d3.csv, '../data/2015-2016/la-liga-goals-chances.csv'
  .defer d3.csv, '../data/2015-2016/bundesliga-teams.csv'
  .defer d3.csv, '../data/2015-2016/bundesliga-goals-chances.csv'
  .defer d3.csv, '../data/2015-2016/serie-a-teams.csv'
  .defer d3.csv, '../data/2015-2016/serie-a-goals-chances.csv'
  .defer d3.csv, '../data/2015-2016/ligue-one-teams.csv'
  .defer d3.csv, '../data/2015-2016/ligue-one-goals-chances.csv'
  .defer d3.csv, '../data/2015-2016/rfpl-teams.csv'
  .defer d3.csv, '../data/2015-2016/rfpl-results.csv'
  .awaitAll parseData

  return
