@Comment = React.createClass
	displayName: 'Comment'

	propTypes:
		key: React.PropTypes.number
		id: React.PropTypes.number
		content: React.PropTypes.string
		timeAgo: React.PropTypes.string
		userName: React.PropTypes.string
		isResponse: React.PropTypes.bool
		removeHandler: React.PropTypes.func
		respondHandler: React.PropTypes.func

	getDefaultProps: ->
		key: null
		id: null
		content: ''
		timeAgo: 'Just now'
		userName: 'You'
		isResponse: false
		removeHandler: null
		respondHandler: null

	handleDelete: (e) ->
		props = @props
		e.preventDefault()
		if confirm("Are you sure you want to delete this comment?") == true
			$.ajax
				method: 'DELETE'
				url: "/groups/1/comments/" + @props.id
				dataType: 'JSON'
				success: ->
					console.log('comment deleted')
					props.removeHandler(props.id)

	handleRespond: (e) ->
		e.preventDefault()
		@props.respondHandler(@props.id)

	render: ->
		React.DOM.div
			className: ''
			style: if @props.isResponse == true then {paddingLeft: '50px'} else null
			React.DOM.div
				className: ''
				@props.userName
			React.DOM.div
				className: ''
				@props.content
			React.DOM.span
				className: ''
				style: {color: 'gray', fontSize: '10px'}
				@props.timeAgo
			React.DOM.a
				className: ''
				href: '#'
				onClick: @handleDelete
				' Delete '
			if @props.isResponse == false
				React.DOM.a
					className: ''
					href: '#'
					onClick: @handleRespond
					' Respond '
			React.DOM.hr
				className: ''
				style: {borderColor: 'gray'}
