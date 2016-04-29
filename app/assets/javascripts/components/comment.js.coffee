@Comment = React.createClass
	displayName: 'Comment'

	propTypes:
		id: React.PropTypes.number
		content: React.PropTypes.string
		timeAgo: React.PropTypes.string
		userName: React.PropTypes.string
		showResponseFormHandler: React.PropTypes.func

	getDefaultProps: ->
		id: null
		content: ''
		timeAgo: 'less than a minute ago'
		userName: 'You'
		showResponseFormHandler: null

	handleNewResponse: (e) ->
		e.preventDefault()
		@props.showResponseFormHandler(@props.id)

	render: ->
		React.DOM.div
			className: ''
			React.DOM.div
				className: ''
				style: {fontWeight: 'bold'}
				@props.userName
			React.DOM.div
				className: ''
				@props.content
			React.DOM.span
				className: ''
				style: {color: 'gray', fontSize: '10px'}
				@props.timeAgo + ' | '
			if @props.showResponseFormHandler != null
				React.DOM.a
					className: ''
					href: '#'
					onClick: @handleNewResponse
					'Respond'
			React.DOM.hr
				className: ''
				style: {borderColor: 'gray'}