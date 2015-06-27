@ReadingButton = React.createClass
  displayName: "ReadingButton"

  getInitialState: ->
    reading_id:  @props.reading_id
    membership_id:  @props.membership_id
    membership_reading_id: @props.membership_reading_id

  getDefaultProps: ->
    membership_reading: null
    reading_id: null
    membership_id: null

  handleDelete: (e) ->
    e.preventDefault()
    $.ajax
      method: 'DELETE'
      url: "/membership_readings/" + @state.membership_reading_id
      dataType: 'JSON'
      success: () =>
        console.log('deleted')
        @setState membership_reading_id: null

  handleCreate: (e) ->
    e.preventDefault()
    $.post '/membership_readings.json', { reading_id: @state.reading_id, membership_id: @state.membership_id }, (data) =>
      @setState membership_reading_id: data.id

  render: ->
    if @state.membership_reading_id
      React.DOM.a
        className: 'glyphicon glyphicon-check btn btn-success delete'
        "data-confirm": 'Are you sure you want to uncheck this reading?  This may affect your statistics; in particular, your "on_time" statistics.'
        onClick: @handleDelete
        " "
    else
      React.DOM.a
        className: 'glyphicon glyphicon-unchecked btn btn-primary'
        onClick: @handleCreate
        " "
