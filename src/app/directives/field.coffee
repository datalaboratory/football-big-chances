app.directive 'field', ->
  coeff =
    big: 3.36
    small: 1
  xOffset =
    big: 41
    small: 1
  restrict: 'E'
  templateNamespace: 'svg'
  templateUrl: 'templates/directives/field.html'
  scope:
    selectedTeam: '='
    type: '@'
  link: ($scope, $element, $attrs) ->
    $scope.getX = (original) ->
      original / coeff.big + xOffset.big

    $scope.getY = (original) ->
      original / coeff.big

    return
