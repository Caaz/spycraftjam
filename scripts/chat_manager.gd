extends Node

const CHATBOX = preload("uid://c3ldpk7fb7lkh")

var narrative_layer:CanvasLayer:
	get:
		return get_tree().get_first_node_in_group("narrative_layer") as CanvasLayer

func start_chat(conversation:Conversation) -> void:
	GameManager.state = GameManager.State.PAUSED
	for chat_message:ChatMessage in conversation.messages:
		var chatbox:Chatbox = CHATBOX.instantiate() as Chatbox
		chatbox.chat_message = chat_message
		narrative_layer.add_child(chatbox)
		await chatbox.dismissed
	GameManager.state = GameManager.State.DEFAULT
