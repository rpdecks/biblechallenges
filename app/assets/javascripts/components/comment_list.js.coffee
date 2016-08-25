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
		for comment, i in @state.comments by -1
			if comment.id == commentId
				comment.comments.push(newResponse)
				break
		@setState comments: @state.comments
		@setState showingResponseFormForCommentId: commentId

	addComment: (id, content) ->
		@closeAnyOpenResponseForm()
		newComment = 
			id: id
			content: content
			timeAgo: 'Just now'
			user: @props.currentUser
			comments: []
		@state.comments.push(newComment)
		@setState comments: @state.comments

	addResponse: (id, content, forCommentId) ->
		@closeAnyOpenResponseForm()
		newResponse = 
			id: id
			content: content,
			timeAgo: 'Just now'
			user: @props.currentUser
		for comment, i in @state.comments by -1
			if comment.id == forCommentId
				comment.comments.push(newResponse)
				break
		@setState comments: @state.comments

	closeAnyOpenResponseForm: ->
		showingResponseFormForCommentId = @state.showingResponseFormForCommentId
		if showingResponseFormForCommentId != null
			for comment, i in @state.comments by -1
				if comment.id == showingResponseFormForCommentId
					comment.comments.pop() # remove previously showing response form
					break
		@setState showingResponseFormForCommentId: null

	removeComment: (commentId) ->
		state = @state
		isResponseDeleted = false
		for comment, i in state.comments by -1
			if isResponseDeleted == true then break #// exit loop if the comment is a response and it's already deleted (below)
			if comment.id == commentId
				state.comments.splice(i, 1)
				break
			for response, j in comment.comments by -1
				if response.id == commentId
					comment.comments.splice(j, 1)
					isResponseDeleted = true
					break
		@setState comments: state.comments

	render: ->
		React.DOM.div
			className: 'comment-list'
			React.DOM.br null
			React.createElement CommentForm,
				commentableType: @props.commentableType
				commentableId: @props.commentableId
				currentUser: @props.currentUser
				addCommentHandler: @addComment
			if @state.comments.length == 0
				React.DOM.div
					className: 'comment-list__no-comments'
			for comment in @state.comments by -1
				React.DOM.div
					className: ''
					React.createElement Comment,
						key: comment.id
						comment: comment
						isResponse: false
						currentUser: @props.currentUser
						removeHandler: @removeComment
						respondHandler: @showResponseForm
					for response in comment.comments # render comment responses
						if response.id == 'new-response-form'
							React.createElement CommentForm,
								commentableType: @props.commentableType
								commentableId: @props.commentableId
								isResponse: true
								responseForCommentId: comment.id
								currentUser: @props.currentUser
								addResponseHandler: @addResponse
						else
							React.createElement Comment,
								key: response.id
								comment: response
								isResponse: true
								responseForCommentId: comment.id
								currentUser: @props.currentUser
								removeHandler: @removeComment
								respondHandler: @showResponseForm
