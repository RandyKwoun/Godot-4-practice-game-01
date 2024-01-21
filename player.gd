extends CharacterBody2D

enum State {
	IDLE,
	MOVE,
	JUMP,
	ATTACK
}

var current_state

@onready var anim = $AnimatedSprite2D

const speed = 4000
const max_speed = 1500
const friction = 500
const jump = 350
const gravity = 1250
var direction = "right"

func _ready():
	current_state = State.IDLE

#Main
func _physics_process(delta):
	player_movement(delta)
	player_falling(delta)
	player_jump(delta)
	#player_attacking()
	
	move_and_slide()
	
	play_anim()
	
	check_alive()

#func player_attacking():
#	if Input.is_action_just_pressed("Attack"):
#		if is_on_floor():
#			velocity.x = 0
#			current_state = State.ATTACK
	
#Make player falling when the player isn't on the floor
func player_falling(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

#Make the player jumping when the player on the floor
func player_jump(delta):
		if is_on_floor():
			if Input.is_action_just_pressed("Jump"):
				current_state = State.JUMP
				velocity.y = -jump 

#Make the player move left or right or jump
func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		if is_on_floor():
			current_state = State.MOVE
		else:
			current_state = State.JUMP
		direction = "right"
		velocity.x = move_toward(0, max_speed, speed * delta)
	
	elif Input.is_action_pressed("ui_left"):
		if is_on_floor():
			current_state = State.MOVE
		else:
			current_state = State.JUMP
		direction = "left"
		velocity.x = -move_toward(0, max_speed, speed * delta)
		
	elif velocity.x == 0 and is_on_floor():
		current_state = State.IDLE
		
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

#play the animations
func play_anim():
	var dir = direction
	
	if dir == "right":
		anim.flip_h = false
		
	elif dir == "left":
		anim.flip_h = true
		
	if current_state == State.MOVE:
		anim.play("Move")
	elif current_state == State.IDLE:
		anim.play("Idle")
	elif current_state == State.JUMP:
		anim.play("Jump")
	elif current_state == State.ATTACK:
		anim.play("Attack")
		
func check_alive():
	if position.y >= 120:
		position = Vector2(50, 116)
