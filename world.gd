extends Node2D

@onready var music = $BGM

func _physics_process(delta):
	if !music.playing:
		music.play()
