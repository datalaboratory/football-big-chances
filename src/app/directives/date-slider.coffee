app.directive 'dateSlider', ($document) ->
  restrict: 'E'
  templateUrl: 'templates/directives/date-slider.html'
  scope:
    allDates: '='
    matchDates: '='
    startDate: '='
    leftDate: '='
    rightDate: '='
    monthNames: '='
  link: ($scope, $element, $attrs) ->
    sliderWidth = $element[0].getBoundingClientRect().width
    sliderLeftOffset = $element.offset().left
    $leftHandle = $element.find '.left-handle'
    $rightHandle = $element.find '.right-handle'
    tickWidth = 1
    nOfDays = $scope.allDates.length
    step = sliderWidth / nOfDays

    $scope.handleShift = $leftHandle.width()
    $scope.leftX = moment($scope.leftDate).diff($scope.startDate, 'days') * step
    $scope.rightX = moment($scope.rightDate).diff($scope.startDate, 'days') * step

    $scope.getCurrentDay = (type) ->
      mDate = moment(if type is 'left' then $scope.leftDate else $scope.rightDate)
      if !mDate.isSame($scope.startDate)
        mDate.date() + ' ' + $scope.monthNames[mDate.month()][1]
      else
        ''

    $scope.getDateX = (date) ->
      moment(date).diff($scope.startDate, 'days') * step

    $scope.getCaptionText = (date, isStart) ->
      day = moment(date).date()
      month = moment(date).month()
      year = moment(date).year()

      if isStart or day is 1 and !month
        $scope.monthNames[month][0] + ' ' + year
      else if day is 1
        $scope.monthNames[month][0]
      else
        ''

    $scope.isCaptionHidden = (date) ->
      moment(date).month() is moment($scope.leftDate).month() and !moment($scope.leftDate).isSame($scope.startDate) or
      moment(date).month() is moment($scope.rightDate).month() and !moment($scope.rightDate).isSame($scope.startDate)

    $leftHandle.on 'mousedown', (event) ->
      mousemove = (event) ->
        daysFromStart = Math.floor (event.clientX - sliderLeftOffset) / step
        daysFromStart = 0 if daysFromStart < 0
        daysFromStart = moment($scope.rightDate).diff($scope.startDate, 'days') - 1 if daysFromStart > moment($scope.rightDate).diff($scope.startDate, 'days') - 1

        $scope.leftX = daysFromStart * step
        $scope.leftDate = moment($scope.startDate).add(daysFromStart, 'days').toDate()

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

    $rightHandle.on 'mousedown', (event) ->
      mousemove = (event) ->
        daysFromStart = Math.floor (event.clientX - sliderLeftOffset) / step
        daysFromStart = moment($scope.leftDate).diff($scope.startDate, 'days') + 1 if daysFromStart < moment($scope.leftDate).diff($scope.startDate, 'days') + 1
        daysFromStart = nOfDays - 1 if daysFromStart > nOfDays - 1

        $scope.rightX = daysFromStart * step
        $scope.rightDate = moment($scope.startDate).add(daysFromStart, 'days').toDate()

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
