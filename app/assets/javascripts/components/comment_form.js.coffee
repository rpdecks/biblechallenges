@CommentForm = React.createClass
	displayName: 'CommentForm'

	propTypes:
		forResponse: React.PropTypes.bool
		responseForCommentId: React.PropTypes.any
		createCommentHandler: React.PropTypes.func

	getDefaultProps: ->
		forResponse: false
		responseForCommentId: null
		createCommentHandler: null

	componentDidMount: ->
		@refs.postButton.disabled = true
		if @props.forResponse == true
			@refs.newCommentInput.focus()

	handleOnChange: (e) ->
		if @refs.newCommentInput.value.trim() != ''
			@refs.postButton.disabled = false
		else
			@refs.postButton.disabled = true

	handlePostComment: ->
		textInput = @refs.newCommentInput
		@props.createCommentHandler(textInput.value, @props.forResponse, @props.responseForCommentId)
		textInput.value = ''
		@refs.postButton.disabled = true

	render: ->
		React.DOM.div
			className: ''
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