app.directive 'tablesHeader', ($window, $document) ->
  restrict: 'E'
  templateUrl: 'templates/directives/tables-header.html'
  link: ($scope, $element, $attrs) ->
    tablesHeaderInitialPos = $element.find('.tables-header').offset().top

    $scope.isFixed = false

    angular.element($window).bind 'scroll', ->
      $scope.isFixed = $document.scrollTop() > tablesHeaderInitialPos
      $scope.$apply()
      return
    return
