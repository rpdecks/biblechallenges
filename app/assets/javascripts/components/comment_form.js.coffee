@CommentForm = React.createClass
	displayName: 'CommentForm'

	propTypes:
		commentableType: React.PropTypes.string
		commentableId: React.PropTypes.number
		addCommentHandler: React.PropTypes.func
		isResponse: React.PropTypes.bool
		responseForCommentId: React.PropTypes.any
		addResponseHandler: React.PropTypes.func

	getDefaultProps: ->
		commentableType: ''
		commentableId: null
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
					commentable_type: props.commentableType
					commentable_id: props.commentableId
		else
			data =
				comment:
					content: refs.newCommentInput.value
					commentable_type: 'Comment'
					commentable_id: props.responseForCommentId
		$.ajax
			method: 'POST'
			url: '/' + props.commentableType.toLowerCase() + 's/' + props.commentableId + '/comments'
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