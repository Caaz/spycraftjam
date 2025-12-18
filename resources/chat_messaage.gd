class_name ChatMessage extends Resource

enum Character {NONE, PLAYER, GUARD, FRIEND, AI}
var character_color:Dictionary[Character,Color] = {
	Character.NONE: Color.WHITE,
	Character.PLAYER: Color("#8dfdfe"),
	Character.GUARD: Color("#e0e03d"),
	Character.FRIEND: Color(0.84, 0.378, 0.832, 1.0),
	Character.AI: Color.WEB_GRAY,
}
var character_texture:Dictionary[Character,Texture] = {
	Character.PLAYER: preload("uid://cglrmybj2limr"),
	Character.GUARD: preload("uid://bi54pmafe1waa"),
}

@export var name:String
@export var character:Character

@export_multiline var content:String

var color:Color:
	get: return character_color[character]
var texture:Texture:
	get: return character_texture.get(character)
