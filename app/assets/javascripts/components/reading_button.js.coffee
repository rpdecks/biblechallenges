@ReadingButton = React.createClass
  displayName: "ReadingButton"

  getInitialState: ->
    reading_id:  @props.reading_id
    membership_id:  @props.membership_id
    membership_reading_id: @props.membership_reading_id

  getDefaultProps: ->
    membership_reading_id: null
    reading_id: null
    membership_id: null

  handleCreate: (e) ->
    e.preventDefault()
    $.post '/membership_readings.json', { reading_id: @state.reading_id, membership_id: @state.membership_id }, (data) =>
      console.log('hi')
      console.log(data.id)
      @setState membership_reading_id: data.id

  render: ->
    if @state.membership_reading_id
      React.DOM.button null, "Mark Unread"
    else
      React.DOM.a
        className: 'btn btn-danger'
        onClick: @handleCreate
        "Mark Read"
