app.directive 'leagueTableRow', ->
  restrict: 'C'
  templateUrl: 'templates/directives/league-table-row.html'
  scope:
    index: '='
    league: '='
    team: '='
    teamValues: '='
    rus: '='
    season: '='
  link: ($scope, $element, $attrs) ->
    return
