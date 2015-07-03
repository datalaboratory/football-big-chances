app.directive 'markers', ->
  restrict: 'E'
  templateNamespace: 'svg'
  templateUrl: 'templates/directives/markers.html'
  link: ($scope, $element, $attrs) ->
    return
