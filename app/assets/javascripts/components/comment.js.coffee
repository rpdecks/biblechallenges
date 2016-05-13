@Comment = React.createClass
	displayName: 'Comment'

	propTypes:
		key: React.PropTypes.number
		id: React.PropTypes.number
		content: React.PropTypes.string
		timeAgo: React.PropTypes.string
		user: React.PropTypes.object
		isResponse: React.PropTypes.bool
		responseForCommentId: React.PropTypes.any
		removeHandler: React.PropTypes.func
		respondHandler: React.PropTypes.func
		currentUser: React.PropTypes.object

	getDefaultProps: ->
		key: null
		id: null
		content: ''
		timeAgo: 'Just now'
		user: null
		isResponse: false
		responseForCommentId: null
		removeHandler: null
		respondHandler: null
		currentUser: null

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
		context = @
		if @props.isResponse == false
			context.props.respondHandler(@props.id)
		else
			context.props.respondHandler(@props.responseForCommentId)

	render: ->
		React.DOM.div
			className: 'react-comment'
			React.DOM.div
				className: 'react-comment__container--' + if @props.isResponse == false then 'comment' else 'response'
				React.DOM.div
					className: 'react-comment__flexbox'
					React.DOM.img
						className: 'react-comment__avatar--' + if @props.isResponse == false then 'comment' else 'response'
						src: @props.user.avatar_path
					React.DOM.div
						className: 'react-comment__content-area'
						React.DOM.span
							className: 'react-comment__username'
							@props.user.name
						React.DOM.span
							className: 'react-comment__content'
							@props.content
						React.DOM.div
							className: 'react-comment__bottom-items--' + if @props.isResponse == false then 'comment' else 'response'
							React.DOM.a
								className: 'react-comment__reply'
								href: '#'
								onClick: @handleRespond
								'Reply'
							React.DOM.span
								className: 'react-comment__dot-separator'
								' · '
							React.DOM.a
								className: 'react-comment__delete'
								href: '#'
								onClick: @handleDelete
								'Delete'
							React.DOM.span
								className: 'react-comment__dot-separator'
								' · '
							React.DOM.span
								className: 'react-comment__timeago'
								@props.timeAgo
