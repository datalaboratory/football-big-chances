app.directive 'sticky', ($window, $document) ->
  restrict: 'C'
  scope:
    offset: '='
    condition: '='
  link: ($scope, $element, $attrs) ->
    elementInitialPos = $element.offset().top

    angular.element($window).bind 'scroll', ->
      isConditionMet = $document.scrollTop() > elementInitialPos - $scope.offset and $scope.condition

      $element.css
        'position': if isConditionMet then 'fixed' else ''
        'top': if isConditionMet then $scope.offset + 'px' else ''
        'background-color': if isConditionMet then '#fff' else ''
        'z-index': if isConditionMet then '1' else ''
      return

    return
