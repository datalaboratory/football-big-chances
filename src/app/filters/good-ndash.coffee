app.filter 'goodNdash', ->
  (value) ->
    value.replace '-', '–'
