app.directive 'dateSlider', ->
  restrict: 'E'
  templateUrl: 'templates/directives/date-slider.html'
  scope:
    date: '='
  link: ($scope, $element, $attrs) ->
    return