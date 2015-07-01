app.directive 'sticky', ($window, $document) ->
  restrict: 'A'
  link: ($scope, $element, $attrs) ->
    elementInitialPos = $element.offset().top
    offset = parseInt $attrs['offset']

    angular.element($window).bind 'scroll', ->
      isConditionMet = $document.scrollTop() > elementInitialPos - offset

      $element.css
        'position': if isConditionMet then 'fixed' else ''
        'top': if isConditionMet then offset + 'px' else ''
        'background-color': if isConditionMet then '#fff' else ''
        'z-index': if isConditionMet then '1' else ''
      return

    return
