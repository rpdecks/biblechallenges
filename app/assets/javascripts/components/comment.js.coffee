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

	getInitialState: ->
		isBusy: false

	handleDelete: (e) ->
		context = @
		e.preventDefault()
		if confirm("Are you sure you want to delete this comment?") == true
			$.ajax
				method: 'DELETE'
				url: "/groups/1/comments/" + context.props.id
				dataType: 'JSON'
				timeout: 10000
				beforeSend: ->
					context.setState isBusy: true
				success: ->
					console.log('comment deleted')
					context.props.removeHandler(context.props.id)
				error: (jqXHR, textStatus, errorThrown) ->
					if textStatus == 'timeout'
						alert("Sorry, it's taking too long for your request to be sent. Please check your connection and try again.")
					else
						alert('Sorry, your request could not be processed. Please try again after some time.')
					context.setState isBusy: false

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
						src: @props.user.avatar_url
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
							if @props.user.id == @props.currentUser.id
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
								@props.timeAgo
							if @state.isBusy == true
								React.DOM.span
									className: null
									React.DOM.span
										className: 'react-comment__dot-separator'
										' · '
									React.DOM.i
										className: 'fa fa-refresh fa-spin'
