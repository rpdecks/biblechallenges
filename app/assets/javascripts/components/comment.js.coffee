@Comment = React.createClass
	displayName: 'Comment'

	propTypes:
		key: React.PropTypes.number
		comment: React.PropTypes.object
		isResponse: React.PropTypes.bool
		responseForCommentId: React.PropTypes.any
		currentUser: React.PropTypes.object
		removeHandler: React.PropTypes.func
		respondHandler: React.PropTypes.func

	getDefaultProps: ->
		key: null
		comment:
			id: null
			content: ''
			timeAgo: 'Just now'
			user: null
		isResponse: false
		responseForCommentId: null
		currentUser: null
		removeHandler: null
		respondHandler: null

	getInitialState: ->
		isBusy: false

	handleDelete: (e) ->
		context = @
		e.preventDefault()
		if confirm("Are you sure you want to delete this comment?") == true
			$.ajax
				method: 'DELETE'
				url: "/comments/" + context.props.comment.id
				dataType: 'JSON'
				timeout: 15000
				beforeSend: ->
					context.setState isBusy: true
				success: ->
					console.log('comment deleted')
					context.props.removeHandler(context.props.comment.id)
				error: ->
					alert('Sorry, unable to process your request now. Please try again later.')
					context.setState isBusy: false

	handleRespond: (e) ->
		e.preventDefault()
		context = @
		if @props.isResponse == false
			context.props.respondHandler(@props.comment.id)
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
						src: @props.comment.user.avatar_path
					React.DOM.div
						className: 'react-comment__content-area'
						React.DOM.span
							className: 'react-comment__username'
							@props.comment.user.name
						React.DOM.span
							className: 'react-comment__content'
							@props.comment.content
						React.DOM.div
							className: 'react-comment__bottom-items--' + if @props.isResponse == false then 'comment' else 'response'
							React.DOM.a
								className: 'react-comment__reply'
								href: '#'
								onClick: @handleRespond
								'Reply'
							if @props.comment.user.id == @props.currentUser.id
								React.DOM.span
									className: null
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
								@props.comment.timeAgo
							if @state.isBusy == true
								React.DOM.span
									className: null
									React.DOM.span
										className: 'react-comment__dot-separator'
										' · '
									React.DOM.i
										className: 'fa fa-refresh fa-spin'
