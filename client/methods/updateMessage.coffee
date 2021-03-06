Meteor.methods
	updateMessage: (message) ->
		if not Meteor.userId()
			throw new Meteor.Error 203, t('User_logged_out')

		originalMessage = ChatMessage.findOne message._id

		hasPermission = RocketChat.authz.hasAtLeastOnePermission('edit-message', message.rid)
		editAllowed = RocketChat.settings.get 'Message_AllowEditing'
		editOwn = originalMessage?.u?._id is Meteor.userId()

		unless hasPermission or (editAllowed and editOwn)
			throw new Meteor.Error 'message-editing-not-allowed', t('Message_editing_not_allowed')

		Tracker.nonreactive ->

			message.ets = new Date(Date.now() + TimeSync.serverOffset())
			message = RocketChat.callbacks.run 'beforeSaveMessage', message

			ChatMessage.update
				_id: message.id
				'u._id': Meteor.userId()
			,
				$set:
					ets: message.ets
					msg: message.msg
