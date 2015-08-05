app.directive 'legend', ->
  restrict: 'E'
  templateNamespace: 'svg'
  templateUrl: 'templates/directives/legend.html'
  scope:
    shownTypes: '='
    team: '='
    linesData: '='
    currentDate: '='
  link: ($scope, $element, $attrs) ->
    $scope.legendItems = [
      {
        title: 'Явный голевой момент → гол'
        type: 'cg'
        lineMarker: 'url(#common-goal)'
        lineClass: 'goal'
      }
      {
        title: '→ Промах'
        type: 'co'
        lineMarker: 'url(#common-big-chance)'
        lineClass: 'big-chance'
      }
      {
        title: '→ Блок'
        type: 'cb'
        lineMarker: 'url(#blocked)'
        lineClass: 'big-chance'
      }
      {
        title: '→ Сейв'
        type: 'cs'
        lineMarker: 'url(#saved)'
        lineClass: 'big-chance'
      }
      {
        title: 'Голы без момента'
        type: 'g'
        lineMarker: 'url(#accidental-goal)'
        lineClass: 'goal'
      }
    ]

    $scope.values =
      cg:
        for: 0
        against: 0
      g:
        for: 0
        against: 0
      co:
        for: 0
        against: 0
      cb:
        for: 0
        against: 0
      cs:
        for: 0
        against: 0

    updateValues = ->
      lines = _.filter $scope.linesData, (L) ->
        moment($scope.currentDate).diff(L.Date, 'days') >= 0

      $scope.values.cg.for = _.filter(lines, (l) -> l.Type is 'CG' and l.Team is $scope.team.name).length
      $scope.values.cg.against = _.filter(lines, (l) -> l.Type is 'CG' and l.Team isnt $scope.team.name).length
      $scope.values.g.for = _.filter(lines, (l) -> l.Type is 'G' and l.Team is $scope.team.name).length
      $scope.values.g.against = _.filter(lines, (l) -> l.Type is 'G' and l.Team isnt $scope.team.name).length
      $scope.values.co.for = _.filter(lines, (l) -> l.Type is 'CO' and l.Team is $scope.team.name).length
      $scope.values.co.against = _.filter(lines, (l) -> l.Type is 'CO' and l.Team isnt $scope.team.name).length
      $scope.values.cb.for = _.filter(lines, (l) -> l.Type is 'CB' and l.Team is $scope.team.name).length
      $scope.values.cb.against = _.filter(lines, (l) -> l.Type is 'CB' and l.Team isnt $scope.team.name).length
      $scope.values.cs.for = _.filter(lines, (l) -> l.Type is 'CS' and l.Team is $scope.team.name).length
      $scope.values.cs.against = _.filter(lines, (l) -> l.Type is 'CS' and l.Team isnt $scope.team.name).length
      return

    $scope.$watch 'currentDate', -> updateValues()

    $scope.$watch 'team', (-> updateValues()), true

    $scope.itemClick = (type) ->
      if $scope.shownTypes.indexOf(type) is -1
        $scope.shownTypes.push type
      else
        $scope.shownTypes = _.filter $scope.shownTypes, (t) -> t isnt type

    $scope.isItemSelected = (type) ->
      $scope.shownTypes.indexOf(type) isnt -1

    return
