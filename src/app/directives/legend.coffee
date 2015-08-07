app.directive 'legend', ->
  restrict: 'E'
  templateNamespace: 'svg'
  templateUrl: 'templates/directives/legend.html'
  scope:
    shownTypes: '='
    team: '='
    linesData: '='
    leftDate: '='
    rightDate: '='
  link: ($scope, $element, $attrs) ->
    $scope.legendItems = [
      {
        title: 'Гол без момента'
        type: 'G'
        lineMarker: 'url(#accidental-goal)'
        lineClass: 'goal'
      }
      {
        title: 'Гол'
        type: 'CG'
        lineMarker: 'url(#common-goal)'
        lineClass: 'goal'
      }
      {
        title: 'Промах'
        type: 'CO'
        lineMarker: 'url(#common-big-chance)'
        lineClass: 'big-chance'
      }
      {
        title: 'Блок'
        type: 'CB'
        lineMarker: 'url(#blocked)'
        lineClass: 'big-chance'
      }
      {
        title: 'Сейв'
        type: 'CS'
        lineMarker: 'url(#saved)'
        lineClass: 'big-chance'
      }
    ]

    $scope.values =
      CG:
        for: 0
        against: 0
      G:
        for: 0
        against: 0
      CO:
        for: 0
        against: 0
      CB:
        for: 0
        against: 0
      CS:
        for: 0
        against: 0

    updateValues = ->
      lines = _.filter $scope.linesData, (L) ->
        moment($scope.leftDate).diff(L.Date, 'days') <= 0 and moment($scope.rightDate).diff(L.Date, 'days') >= 0

      $scope.values.CG.for = _.filter(lines, (l) -> l.Type is 'CG' and l.Team is $scope.team.name).length
      $scope.values.CG.against = _.filter(lines, (l) -> l.Type is 'CG' and l.Team isnt $scope.team.name).length
      $scope.values.G.for = _.filter(lines, (l) -> l.Type is 'G' and l.Team is $scope.team.name).length
      $scope.values.G.against = _.filter(lines, (l) -> l.Type is 'G' and l.Team isnt $scope.team.name).length
      $scope.values.CO.for = _.filter(lines, (l) -> l.Type is 'CO' and l.Team is $scope.team.name).length
      $scope.values.CO.against = _.filter(lines, (l) -> l.Type is 'CO' and l.Team isnt $scope.team.name).length
      $scope.values.CB.for = _.filter(lines, (l) -> l.Type is 'CB' and l.Team is $scope.team.name).length
      $scope.values.CB.against = _.filter(lines, (l) -> l.Type is 'CB' and l.Team isnt $scope.team.name).length
      $scope.values.CS.for = _.filter(lines, (l) -> l.Type is 'CS' and l.Team is $scope.team.name).length
      $scope.values.CS.against = _.filter(lines, (l) -> l.Type is 'CS' and l.Team isnt $scope.team.name).length
      return

    $scope.$watch 'leftDate', -> updateValues()

    $scope.$watch 'rightDate', -> updateValues()

    $scope.$watch 'team', (-> updateValues()), true

    $scope.itemClick = (type) ->
      if $scope.shownTypes.indexOf(type) is -1
        $scope.shownTypes.push type
      else
        $scope.shownTypes = _.filter $scope.shownTypes, (t) -> t isnt type

    $scope.isItemSelected = (type) ->
      $scope.shownTypes.indexOf(type) isnt -1

    return
