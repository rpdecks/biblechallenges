@CommentList = React.createClass
	displayName: 'CommentList'

	propTypes:
		title: React.PropTypes.string
		comments: React.PropTypes.array
		currentUserName: React.PropTypes.string

	getInitialState: ->
		comments: @props.comments
		showingResponseFormForCommentId: null

	getDefaultProps: ->
		title: 'Comments'
		comments: []
		currentUserName: 'You'

	createComment: (content, isResponse, responseForCommentId) ->
		@closeAnyOpenResponseForm()
		newComment = 
			id: new Date().getTime() # assign a temporary ID
			content: content,
			userName: @props.currentUserName,
			comments: []
		if isResponse == true
			$.each @state.comments, (i, comment) ->
				if comment.id == responseForCommentId
					comment.comments.push(newComment)
		else
			@state.comments.push(newComment)
		@setState comments: @state.comments

	showResponseForm: (commentId) ->
		@closeAnyOpenResponseForm()
		newResponse =
			id: 'new-response'
		$.each @state.comments, (i, comment) ->
			if comment.id == commentId
				comment.comments.push(newResponse)
		@setState comments: @state.comments
		@setState showingResponseFormForCommentId: commentId

	closeAnyOpenResponseForm: ->
		showingResponseFormForCommentId = @state.showingResponseFormForCommentId
		if showingResponseFormForCommentId != null
			$.each @state.comments, (i, comment) ->
				if comment.id == showingResponseFormForCommentId
					comment.comments.pop() # remove previously showing response form
		@setState showingResponseFormForCommentId: null

	render: ->
		React.DOM.div
			className: ''
			React.DOM.h4
				className: ''
				@props.title
			React.DOM.br
				className: ''
			React.createElement CommentForm,
				createCommentHandler: @createComment
			for comment in @state.comments by -1
				React.DOM.div
					className: ''
					React.createElement Comment,
						key: comment.id
						id: comment.id
						content: comment.content
						timeAgo: comment.timeAgo
						userName: comment.userName
						showResponseFormHandler: @showResponseForm
					for response in comment.comments # render comment responses
						if response.id == 'new-response'
							React.DOM.div
								className: ''
								style: {paddingLeft: '50px'}
								React.createElement CommentForm,
									forResponse: true
									responseForCommentId: comment.id
									createCommentHandler: @createComment
						else
							React.DOM.div
								className: ''
								style: {paddingLeft: '50px'}
								React.createElement Comment,
									key: response.id
									id: response.id
									content: response.content
									timeAgo: response.timeAgo
									userName: response.userName
