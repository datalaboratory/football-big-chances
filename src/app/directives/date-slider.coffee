app.directive 'dateSlider', ($document) ->
  monthNames = [
    ['янв', 'янв'],
    ['фев', 'фев'],
    ['мар', 'мар'],
    ['апр', 'апр'],
    ['май', 'мая'],
    ['июнь', 'июня'],
    ['июль', 'июля'],
    ['авг', 'авг'],
    ['сен', 'сен'],
    ['окт', 'окт'],
    ['ноя', 'ноя'],
    ['дек', 'дек']
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
    tickWidth = 1
    nOfDays = $scope.allDates.length
    step = sliderWidth / nOfDays

    $scope.handleShift = ($handle.width() - tickWidth) / 2
    $scope.currentX = moment($scope.currentDate).diff($scope.startDate, 'days') * step

    $scope.getCurrentDay = ->
      mDate = moment($scope.currentDate)
      if !mDate.isSame($scope.startDate)
        mDate.date() + ' ' + monthNames[mDate.month()][1]
      else
        ''

    $scope.getDateX = (date) ->
      moment(date).diff($scope.startDate, 'days') * step

    $scope.getCaptionText = (date, isStart) ->
      day = moment(date).date()
      month = moment(date).month()
      year = moment(date).year()

      if isStart or day is 1 and !month
        monthNames[month][0] + ' ' + year
      else if day is 1
        monthNames[month][0]
      else
        ''

    $scope.isCaptionHidden = (date) ->
      moment(date).month() is moment($scope.currentDate).month() and !moment($scope.currentDate).isSame($scope.startDate)

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
