app.directive 'seasonsSwitch', ->
  restrict: 'E'
  templateUrl: 'templates/directives/seasons-switch.html'
  scope:
    season: '='
    seasons: '='
  link: ($scope, $element, $attrs) ->
    return
