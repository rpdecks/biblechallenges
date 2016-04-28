@CommentForm = React.createClass
	displayName: 'CommentForm'

	propTypes:
		createCommentHandler: React.PropTypes.func

	getDefaultProps: ->
		createCommentHandler: null

	handlePostComment: (e) ->
		textInput = @refs.newCommentInput
		@props.createCommentHandler(textInput.value)
		textInput.value = ''

	render: ->
		React.DOM.div
			className: 'temp'
			React.DOM.Comment
				React.DOM.textarea
					className: 'temp'
					ref: 'newCommentInput'
				React.DOM.br
					className: 'temp'
				React.DOM.button
					className: 'temp'
					onClick: @handlePostComment
					'Post Comment'
				React.DOM.br
					className: 'temp'
				React.DOM.br
					className: 'temp'
