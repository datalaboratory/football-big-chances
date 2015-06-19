app.directive 'dateSlider', ->
  restrict: 'E'
  templateUrl: 'templates/directives/date-slider.html'
  scope:
    matchDates: '='
    allDates: '='
    startDate: '='
    endDate: '='
    currentDate: '='
    dateFormat: '@'
  link: ($scope, $element, $attrs) ->
    $slider = $($element)
    $handle = $slider.find '.slider-handle'
    $fill = $slider.find '.fill'
    $dateCaption = $slider.find '.current-date-caption'

    sliderWidth = $slider.width()
    sliderLeftOffset = $slider.offset().left
    handleWidth = $handle.width()

    nOfDays = moment($scope.matchDates[$scope.matchDates.length - 1]).diff($scope.startDate, 'days') + 1
    dayWidth = sliderWidth / nOfDays
    monthNames = [
      'янв'
      'фев'
      'мар'
      'апр'
      'май'
      'июнь'
      'июль'
      'авг'
      'сен'
      'окт'
      'ноя'
      'дек'
    ]

    $scope.isHandleClicked = false

    $scope.getCurrentDay = ->
      if !$scope.currentDate.isSame($scope.startDate)
        $scope.currentDate.date()

    $scope.getDateX = (date) ->
      moment(date).diff($scope.startDate, 'days') * dayWidth

    $scope.getCaptionText = (date, isFirst) ->
      day = moment(date).date()
      month = moment(date).month()
      year = moment(date).year()

      if isFirst or day is 1 and !month
        monthNames[month] + ' ' + year
      else if day is 1
        monthNames[month]

    $scope.sliderOnMousemove = ($event) ->
      return unless $scope.isHandleClicked
      
      x = $event.clientX - sliderLeftOffset - handleWidth / 2
      x = -handleWidth / 2 if x < -handleWidth / 2
      x = sliderWidth - handleWidth / 2 if x > sliderWidth - handleWidth / 2
      mdate = moment($scope.startDate).add(Math.floor((x + handleWidth / 2) / dayWidth), 'days')

      $scope.currentDate = mdate if x < sliderWidth - handleWidth / 2
      $scope.currentDate = moment($scope.matchDates[0]).subtract(1, 'days') if x is -handleWidth / 2
      
      $handle.css 'transform', 'translateX(' + x + 'px)'
      $fill.width x + handleWidth / 2
      $dateCaption.css 'transform', 'translateX(' + x + 'px)'
      return
    return