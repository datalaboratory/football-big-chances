app.directive 'viewSwitch', ->
  restrict: 'E'
  templateUrl: 'templates/directives/view-switch.html'
  scope:
    view: '='
  link: ($scope, $element, $attrs) ->
    $scope.lbHovered = false
    $scope.rbHovered = false

    $scope.buttonOnClick = (view) ->
      $scope.view = view
      return

    $scope.isButtonActive = (view) ->
      view is $scope.view

    return
