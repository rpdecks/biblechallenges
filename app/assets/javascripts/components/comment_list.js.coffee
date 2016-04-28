@CommentList = React.createClass
	displayName: 'CommentList'

	propTypes:
		title: React.PropTypes.string
		comments: React.PropTypes.array
		currentUserName: React.PropTypes.string

	getInitialState: ->
		comments: @props.comments

	getDefaultProps: ->
		title: 'Comments'
		comments: []
		currentUserName: 'You'

	handleCreateComment: (content) ->
		newComment = 
			id: undefined,
			content: undefined,
			timeAgo: undefined,
			userName: undefined,
			comments: []
		newComment.content = content
		newComment.userName = @props.currentUserName
		@state.comments.push(newComment)
		@setState comments: @state.comments

	handleNewResponse: (commentId) ->
		$.each @state.comments, (i, comment) ->
			if comment.id == commentId
				comment.comments.push({id: 'new-response'})
		@setState comments: @state.comments

	render: ->
		React.DOM.div
			className: 'temp'
			React.DOM.h4
				className: 'temp'
				@props.title
			React.DOM.br
				className: 'temp'
			React.createElement CommentForm,
				createCommentHandler: @handleCreateComment
			for comment in @state.comments by -1
				React.DOM.div
					className: 'temp'
					React.createElement Comment,
						key: comment.id
						id: comment.id
						content: comment.content
						timeAgo: comment.timeAgo
						userName: comment.userName
						newResponseHandler: @handleNewResponse
					for response in comment.comments by -1
						if response.id == 'new-response'
							React.createElement CommentForm,
								createCommentHandler: @handleCreateComment
						else							
							React.DOM.div
								className: 'response'
								style: {paddingLeft: '50px'}
								React.createElement Comment,
									key: response.id
									id: response.id
									content: response.content
									timeAgo: response.timeAgo
									userName: response.userName
