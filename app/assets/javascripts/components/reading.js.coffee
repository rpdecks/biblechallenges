@Reading = React.createClass

  render: ->
    React.DOM.tr null,
      React.DOM.td null, @props.reading.read_on
      React.DOM.td null, @props.reading.chapter.book_name

