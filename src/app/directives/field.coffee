app.directive 'field', ->
  coeff =
    big: 3.36
    small: 5.17
  xOffset =
    big: 41
    small: 26.6
  restrict: 'E'
  templateNamespace: 'svg'
  templateUrl: 'templates/directives/field.html'
  scope:
    leagueData: '='
    team: '='
    currentDate: '='
    shownTypes: '='
    monthNames: '='
    type: '@'
  link: ($scope, $element, $attrs) ->
    d3element = d3.select $element[0]
    tooltip = $element.find '.tooltip'

    $scope.selectedLine = undefined

    $scope.lines = []

    updateLines = ->
      $scope.lines = []
      return unless $scope.team.league and $scope.team.name

      $scope.lines = _.filter $scope.leagueData[$scope.team.name].Lines, (L) ->
        moment($scope.currentDate).diff(L.Date, 'days') >= 0
      return

    $scope.$watch 'currentDate', -> updateLines()

    $scope.$watch 'team', (-> updateLines()), true

    $scope.getX = (original) ->
      original / coeff[$scope.type] + xOffset[$scope.type]

    $scope.getY = (original) ->
      original / coeff[$scope.type]

    $scope.getStyle = (line) ->
      classes = ''

      if line.Type.indexOf('G') isnt -1
        classes = 'goal'
      else
        classes = 'big-chance'

      if line.Team is $scope.team.name
        classes += ' for'
      else
        classes += ' against'

      classes

    $scope.getMarkerEnd = (line) ->
      if line.Type is 'G'
        'url(#accidental-goal)'
      else if line.Type is 'CG'
        'url(#common-goal)'
      else if line.Type is 'CO'
        'url(#common-big-chance)'
      else if line.Type is 'CB'
        'url(#blocked)'
      else if line.Type is 'CS'
        'url(#saved)'
      else
        ''

    $scope.lineOnMouseover = (line) ->
      $scope.selectedLine = line
      return

    $scope.lineOnMouseleave = ->
      $scope.selectedLine = undefined
      return

    $scope.getFormattedDate = (date) ->
      mDate = moment(date)
      mDate.date() + ' ' + $scope.monthNames[mDate.month()][1]

    $element.mousemove (event) ->
      tooltip.css
        'top': event.clientY + 20
        'left': event.clientX + 10
      return

    return
