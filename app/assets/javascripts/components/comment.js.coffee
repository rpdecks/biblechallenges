@Comment = React.createClass
	displayName: 'Comment'

	propTypes:
		id: React.PropTypes.number
		content: React.PropTypes.string
		timeAgo: React.PropTypes.string
		userName: React.PropTypes.string
		newResponseHandler: React.PropTypes.func

	getDefaultProps: ->
		id: null
		content: ''
		timeAgo: 'Just now'
		userName: 'You'
		newResponseHandler: null

	handleNewResponse: (e) ->
		e.preventDefault()
		@props.newResponseHandler(@props.id)

	render: ->
		React.DOM.div
			className: 'temp'
			React.DOM.div
				className: 'temp'
				@props.userName
			React.DOM.div
				className: 'temp'
				@props.content
			React.DOM.div
				className: 'temp'
				@props.timeAgo
			if @props.newResponseHandler != null
				React.DOM.a
					className: ''
					href: '#'
					onClick: @handleNewResponse
					'Respond'
			React.DOM.hr
				className: 'temp'
				style: {borderColor: 'gray'}