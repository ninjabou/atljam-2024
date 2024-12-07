extends Node2D

signal register_kickable(kickable: Kickable)
signal kick(kickable: Kickable)

var kickables = []

func _ready() -> void:
	self.connect("register_kickable", on_register_kickable)
	self.connect("kick", on_kick)

func on_register_kickable(kickable: Kickable):
	kickables.append(kickable)

func on_kick(kickable: Kickable):
	kickable.kicked()
