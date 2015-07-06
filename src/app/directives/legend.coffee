app.directive 'legend', ->
  restrict: 'E'
  templateNamespace: 'svg'
  templateUrl: 'templates/directives/legend.html'
  link: ($scope, $element, $attrs) ->
    return
