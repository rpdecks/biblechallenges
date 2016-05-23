@CommentList = React.createClass
	displayName: 'CommentList'

	propTypes:
		commentableType: React.PropTypes.string
		commentableId: React.PropTypes.number
		comments: React.PropTypes.array
		currentUser: React.PropTypes.object

	getDefaultProps: ->
		commentableType: ''
		commentableId: null
		comments: []
		currentUser:
			id: null
			name: 'You'
			avatar_path: '/assets/default_avatar.png'

	getInitialState: ->
		comments: @props.comments
		showingResponseFormForCommentId: null

	showResponseForm: (commentId) ->
		@closeAnyOpenResponseForm()
		newResponse =
			id: 'new-response-form' # just a flag
		$.each @state.comments, (i, comment) ->
			if comment.id == commentId
				comment.comments.push(newResponse)
		@setState comments: @state.comments
		@setState showingResponseFormForCommentId: commentId

	addComment: (id, content) ->
		@closeAnyOpenResponseForm()
		newComment = 
			id: id
			content: content
			user: @props.currentUser
			comments: []
		@state.comments.push(newComment)
		@setState comments: @state.comments

	addResponse: (id, content, forCommentId) ->
		@closeAnyOpenResponseForm()
		newResponse = 
			id: id
			content: content,
			user: @props.currentUser
		$.each @state.comments, (i, comment) ->
			if comment.id == forCommentId
				comment.comments.push(newResponse)
		@setState comments: @state.comments

	closeAnyOpenResponseForm: ->
		showingResponseFormForCommentId = @state.showingResponseFormForCommentId
		if showingResponseFormForCommentId != null
			$.each @state.comments, (i, comment) ->
				if comment.id == showingResponseFormForCommentId
					comment.comments.pop() # remove previously showing response form
		@setState showingResponseFormForCommentId: null

	removeComment: (commentId) ->
		state = @state
		for comment, i in state.comments by -1
			if comment.id == commentId
				state.comments.splice(i, 1)
			for response, j in comment.comments by -1
				if response.id == commentId
					comment.comments.splice(j, 1)
		@setState comments: state.comments

	render: ->
		React.DOM.div
			className: 'comment-list'
			React.DOM.br null
			React.createElement CommentForm,
				commentableType: @props.commentableType
				commentableId: @props.commentableId
				addCommentHandler: @addComment
				currentUser: @props.currentUser
			if @state.comments.length == 0
				React.DOM.div
					className: 'comment-list__no-comments'
					'No comments yet!'
			for comment in @state.comments by -1
				React.DOM.div
					className: ''
					React.createElement Comment,
						key: comment.id
						id: comment.id
						content: comment.content
						timeAgo: comment.timeAgo
						user: comment.user
						isResponse: false
						removeHandler: @removeComment
						respondHandler: @showResponseForm
						currentUser: @props.currentUser
					for response in comment.comments # render comment responses
						if response.id == 'new-response-form'
							React.createElement CommentForm,
								commentableType: @props.commentableType
								commentableId: @props.commentableId
								isResponse: true
								responseForCommentId: comment.id
								addResponseHandler: @addResponse
								currentUser: @props.currentUser
						else
							React.createElement Comment,
								key: response.id
								id: response.id
								content: response.content
								timeAgo: response.timeAgo
								user: response.user
								isResponse: true
								responseForCommentId: comment.id
								removeHandler: @removeComment
								respondHandler: @showResponseForm
								currentUser: @props.currentUser
