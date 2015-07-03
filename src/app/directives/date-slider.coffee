app.directive 'dateSlider', ($document) ->
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
  restrict: 'E'
  templateUrl: 'templates/directives/date-slider.html'
  scope:
    allDates: '='
    matchDates: '='
    startDate: '='
    currentDate: '='
  link: ($scope, $element, $attrs) ->
    sliderWidth = $element[0].getBoundingClientRect().width
    sliderLeftOffset = $element.offset().left
    $handle = $element.find '.handle'
    $currentDateCaption = $element.find '.current-date-caption'
    tickWidth = 1
    nOfDays = $scope.allDates.length
    step = sliderWidth / nOfDays

    $scope.handleShift = ($handle.width() - tickWidth) / 2
    $scope.currentDateCaptionShift = ($currentDateCaption.width() - tickWidth) / 2
    $scope.currentX = moment($scope.currentDate).diff($scope.startDate, 'days') * step

    $scope.getCurrentDay = ->
      if !moment($scope.currentDate).isSame($scope.startDate)
        moment($scope.currentDate).date()
      else
        ''

    $scope.getDateX = (date) ->
      moment(date).diff($scope.startDate, 'days') * step

    $scope.getCaptionText = (date, isStart) ->
      day = moment(date).date()
      month = moment(date).month()
      year = moment(date).year()

      if isStart or day is 1 and !month
        monthNames[month] + ' ' + year
      else if day is 1
        monthNames[month]
      else
        ''

    $handle.on 'mousedown', (event) ->
      mousemove = (event) ->
        daysFromStart = Math.floor (event.clientX - sliderLeftOffset) / step
        daysFromStart = 0 if daysFromStart < 0
        daysFromStart = nOfDays - 1 if daysFromStart > nOfDays - 1

        $scope.currentX = daysFromStart * step
        $scope.currentDate = moment($scope.startDate).add(daysFromStart, 'days').toDate()

        $scope.$apply()
        return

      mouseup = ->
        $document.unbind 'mousemove', mousemove
        $document.unbind 'mouseup', mouseup
        return

      event.preventDefault()
      $document.on 'mousemove', mousemove
      $document.on 'mouseup', mouseup
      return

    return
