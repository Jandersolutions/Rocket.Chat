Template.oembedBaseWidget.helpers
	template: ->
		# console.log this
		if this.headers?.contentType?.match(/image\/.*/)?
			return 'oembedImageWidget'

		if this.parsedUrl?.host is 'www.youtube.com' and this.meta?.twitterPlayer?
			return 'oembedYoutubeWidget'

		if this.parsedUrl?.host is 'twitter.com'
			return 'oembedTwitterWidget'

		return 'oembedUrlWidget'