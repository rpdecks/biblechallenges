@CommentList = React.createClass
	displayName: 'CommentList'

	propTypes:
		commentableType: React.PropTypes.string
		commentableId: React.PropTypes.number
		comments: React.PropTypes.array
		currentUserName: React.PropTypes.string

	getDefaultProps: ->
		commentableType: ''
		commentableId: null
		comments: []
		currentUserName: 'You'

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
			content: content,
			userName: @props.currentUserName,
			comments: []
		@state.comments.push(newComment)
		@setState comments: @state.comments

	addResponse: (id, content, forCommentId) ->
		@closeAnyOpenResponseForm()
		newResponse = 
			id: id
			content: content,
			userName: @props.currentUserName,
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
			className: ''
			React.DOM.h4
				className: ''
				@props.commentableType + ' Comments'
			React.DOM.br
				className: ''
			React.createElement CommentForm,
				commentableType: @props.commentableType
				commentableId: @props.commentableId
				addCommentHandler: @addComment
			for comment in @state.comments by -1
				React.DOM.div
					className: ''
					React.createElement Comment,
						key: comment.id
						id: comment.id
						content: comment.content
						timeAgo: comment.timeAgo
						userName: comment.userName
						isResponse: false
						removeHandler: @removeComment
						respondHandler: @showResponseForm
					for response in comment.comments # render comment responses
						if response.id == 'new-response-form'
							React.createElement CommentForm,
								commentableType: @props.commentableType
								commentableId: @props.commentableId
								isResponse: true
								responseForCommentId: comment.id
								addResponseHandler: @addResponse
						else
							React.createElement Comment,
								key: response.id
								id: response.id
								content: response.content
								timeAgo: response.timeAgo
								userName: response.userName
								isResponse: true
								removeHandler: @removeComment
