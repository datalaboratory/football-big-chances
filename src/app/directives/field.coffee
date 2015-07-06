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
    linesData: '='
    team: '='
    currentDate: '='
    showOnly: '='
    type: '@'
  link: ($scope, $element, $attrs) ->
    d3element = d3.select $element[0]

    $scope.lines = []

    updateLines = ->
      $scope.lines = []
      return unless $scope.team.league and $scope.team.name

      $scope.lines = _.filter $scope.linesData, (L) ->
        moment($scope.currentDate).diff(L.Date, 'days') >= 0
      return

    $scope.$watch 'currentDate', -> updateLines()

    $scope.$watch 'team', (-> updateLines()), true

    $scope.$watch 'showOnly', ->
      if $scope.showOnly is 'goals'
        d3element.selectAll('.big-chance').style 'opacity', 0
      else if $scope.showOnly is 'big-chances'
        d3element.selectAll('.goal').style 'opacity', 0
      else
        d3element.selectAll('.line').style 'opacity', ->
          if d3.select(@).classed('past')
            .5
          else
            1
      return

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

      if moment($scope.currentDate).diff(line.Date, 'days')
        classes += ' past'

      classes

    $scope.getMarkerEnd = (line) ->
      if line.Type is 'GF'
        'url(#accidental-goal)'
      else if line.Type is 'CF-G'
        'url(#common-goal)'
      else if line.Type is 'CF-O'
        'url(#common-big-chance)'
      else if line.Type is 'CF-B'
        'url(#blocked)'
      else if line.Type is 'CF-S'
        'url(#saved)'
      else
        ''

    return
