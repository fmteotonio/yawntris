extends Node2D

signal disappear_finished

onready var isActive = true

func _on_AnimatedSprite_animation_finished():
	emit_signal("disappear_finished")
