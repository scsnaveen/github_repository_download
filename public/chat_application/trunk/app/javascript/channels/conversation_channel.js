import consumer from "./consumer"

consumer.subscriptions.create("ConversationChannel", {
	connected() {
		// Called when the subscription is ready for use on the server
	},

	disconnected() {
		// Called when the subscription has been terminated by the server
	},

	received: function(data) {
		var conversation = $('#conversations-list').find("[data-conversation-id='" + data['conversation_id'] + "']");
		conversation.find('.messages-list').find('ul').append(data['message']);

		var messages_list = conversation.find('.messages-list');
		var height = messages_list[0].scrollHeight;
		messages_list.scrollTop(height);
	},

	speak: function(message) {
		return this.perform('speak',{
			message: message
		});
	}
});