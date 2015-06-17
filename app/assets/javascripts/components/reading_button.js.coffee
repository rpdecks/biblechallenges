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

  handleCreate: ->
    e.preventDefault()
    $.post

  render: ->
    if @state.membership_reading_id
      React.DOM.button null, "Mark Unread"
    else
      React.DOM.button null, "Mark Read"
