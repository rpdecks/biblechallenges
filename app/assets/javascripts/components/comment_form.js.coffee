@CommentForm = React.createClass
	displayName: 'CommentForm'

	propTypes:
		addCommentHandler: React.PropTypes.func
		isResponse: React.PropTypes.bool
		responseForCommentId: React.PropTypes.any
		addResponseHandler: React.PropTypes.func

	getDefaultProps: ->
		addCommentHandler: null
		isResponse: false
		responseForCommentId: null
		addResponseHandler: null

	componentDidMount: ->
		@refs.postButton.disabled = true
		if @props.isResponse == true
			@refs.newCommentInput.focus()

	handleOnChange: (e) ->
		if @refs.newCommentInput.value.trim() != ''
			@refs.postButton.disabled = false
		else
			@refs.postButton.disabled = true

	handlePostComment: ->
		props = @props
		refs = @refs
		if props.isResponse == false
			data =
				comment:
					content: refs.newCommentInput.value
					commentable_id: 1
					commentable_type: 'Group'
		else
			data =
				comment:
					content: refs.newCommentInput.value
					commentable_id: props.responseForCommentId
					commentable_type: 'Comment'
		$.ajax
			method: 'POST'
			url: "/groups/1/comments"
			dataType: 'JSON'
			data: data
			success: (result) ->
				console.log('comment created')
				if props.isResponse == false
					props.addCommentHandler(result.id, refs.newCommentInput.value)
					refs.newCommentInput.value = ''
					refs.postButton.disabled = true
				else
					props.addResponseHandler(result.id, refs.newCommentInput.value, props.responseForCommentId)

	render: ->
		React.DOM.div
			className: ''
			style: if @props.isResponse == true then {paddingLeft: '50px'} else null
			React.DOM.Comment
				React.DOM.textarea
					className: ''
					style: {marginRight: '10px'}
					ref: 'newCommentInput'
					onChange: @handleOnChange
				React.DOM.button
					className: ''
					ref: 'postButton'
					onClick: @handlePostComment
					'Post Comment'
				React.DOM.hr
					className: ''
					style: {borderColor: 'gray'}