app.directive 'tableHeader', ->
  restrict: 'E'
  templateUrl: 'templates/directives/table-header.html'
  link: ($scope, $element, $attrs) ->
    return