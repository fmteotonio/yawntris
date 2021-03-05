extends Node2D

signal warning_finished
signal close_finished
signal open_finished

func _on_AnimatedSprite_animation_finished():
	if get_node("AnimatedSprite").animation == "Warning":
		emit_signal("warning_finished")
	elif get_node("AnimatedSprite").animation == "Close":
		emit_signal("close_finished")
	elif get_node("AnimatedSprite").animation == "Open":
		emit_signal("open_finished")
