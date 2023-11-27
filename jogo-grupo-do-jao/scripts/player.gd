extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const ATTACK_DAMAGE = 20.0
const ATTACK_COOLDOWN = 0.5  # Tempo em segundos entre os ataques

var attack_timer = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false

@onready var animation := $animacao as AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

   # Handle Attack
	attack_timer -= delta
	if Input.is_action_just_pressed("attack") and attack_timer <= 0.0:
		attack()
		attack_timer = ATTACK_COOLDOWN

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		if !is_jumping:
			animation.play("run")
		elif is_jumping:
			animation.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")
	move_and_slide()

func attack():
	print("Ataque!")
