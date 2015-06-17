@Readings = React.createClass

  getInitialState: ->
    readings: @props.data

  getDefaultProps: ->
    readings: []

  render: ->
    React.DOM.div
      className: 'readings'
      React.DOM.h2
        className: 'title'
        'Readings'
      React.DOM.table
        className: 'table table-bordered'
        for reading in @state.readings
          React.createElement Reading, key: reading.id, reading: reading
