app.directive 'viewSwitch', ->
  restrict: 'E'
  templateUrl: 'templates/directives/view-switch.html'
  scope:
    view: '='
    shownTypes: '='
  link: ($scope, $element, $attrs) ->
    $scope.lbHovered = false
    $scope.rbHovered = false

    $scope.buttonOnClick = (view) ->
      $scope.view = view
      if view is 'fileds'
        $scope.shownTypes = ['G', 'CG', 'CO', 'CB', 'CS']
      return

    $scope.isButtonActive = (view) ->
      view is $scope.view

    return
