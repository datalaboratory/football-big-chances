app.directive 'field', ->
  restrict: 'E'
  replace: true
  templateNamespace: 'svg'
  templateUrl: 'templates/directives/field.html'
  scope:
    selectedTeam: '='
    type: '@'
  link: ($scope, $element, $attrs) ->
    return
