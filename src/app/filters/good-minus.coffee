app.filter 'goodMinus', ->
  (value) ->
    if value < 0
      '−' + Math.abs value
    else
      value
