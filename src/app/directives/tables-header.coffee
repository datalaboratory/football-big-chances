app.directive 'tablesHeader', ($window, $document) ->
  restrict: 'E'
  templateUrl: 'templates/directives/tables-header.html'
  scope:
    sortBy: '='
    sortingOrder: '='
  link: ($scope, $element, $attrs) ->
    $scope.sortableOnClick = (value) ->
      if $scope.sortBy is value
        $scope.sortingOrder = !$scope.sortingOrder
      else
        $scope.sortBy = value
        $scope.sortingOrder = true
      return

    return
