app.directive 'tablesHeader', ($window, $document) ->
  restrict: 'E'
  templateUrl: 'templates/directives/tables-header.html'
  link: ($scope, $element, $attrs) ->
    return
