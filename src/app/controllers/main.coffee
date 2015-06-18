app.controller 'MainCtrl', ($scope) ->
  $scope.leagues =
    premierLeague: active: true
    laLiga: active: false
    bundesliga: active: false
    serieA: active: false
    ligueOne: active: false

  $scope.view = 'field-table'

  $scope.date = undefined
  return