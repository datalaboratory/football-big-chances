app.directive 'field', ->
  restrict: 'E'
  templateUrl: 'templates/directives/field.html'
  scope:
    selectedTeam: '='
  link: ($scope, $element, $attrs) ->
    return
