app.directive 'sticky', ($window, $document) ->
  restrict: 'C'
  scope:
    offset: '='
    initialPos: '='
    condition: '='
  link: ($scope, $element, $attrs) ->
    angular.element($window).bind 'scroll', ->
      isConditionMet = $document.scrollTop() > $scope.initialPos - $scope.offset and $scope.condition

      $element.css
        'position': if isConditionMet then 'fixed' else ''
        'top': if isConditionMet then $scope.offset + 'px' else ''
        'background-color': if isConditionMet then '#fff' else ''
        'z-index': if isConditionMet then '1' else ''
      return

    return
