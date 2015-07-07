app.directive 'datalabFooter', ->
  restrict: 'E'
  templateUrl: 'templates/directives/datalab-footer.html'
  link: ($scope, $element, $attrs) ->
    $element.find('.likely').socialLikes({forceUpdate: true})

    return
