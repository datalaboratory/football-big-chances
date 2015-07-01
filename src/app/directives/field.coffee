app.directive 'field', ($window, $document) ->
  restrict: 'E'
  templateUrl: 'templates/directives/field.html'
  link: ($scope, $element, $attrs) ->
    return
