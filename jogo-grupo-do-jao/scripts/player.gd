extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const ATTACK_DAMAGE = 20.0
const ATTACK_COOLDOWN = 0.5  # Tempo em segundos entre os ataques
var direction
var attack_timer = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var is_hurted := false
var player_life := 2
var knockback_vector := Vector2.ZERO

@onready var animation := $animacao as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D

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
	direction = Input.get_axis("ui_left", "ui_right")
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
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	move_and_slide()

func attack():
	print("Ataque!")


func _on_hurtbox_body_entered(body):
#	if body.is_in_group("enemies"):
	if player_life < 0:
		queue_free()
	else:
		if $ray_right.is_colliding():
			take_damage(Vector2(-100,-100))
		elif $ray_right.is_colliding():
			take_damage(Vector2(100,-100))
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
		player_life -= 1
		
		if knockback_force != Vector2.ZERO:
			knockback_vector = knockback_force
			
			var knockback_tween := get_tree().create_tween()
			knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
			animation.modulate = Color(1, 0, 0, 1)
			knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)
		
		is_hurted = true
		await get_tree().create_timer(.9).timeout
		is_hurted = false
		
func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state="jump"
	elif direction != 0:
		state="run"
	if is_hurted:
		state="hurt"

	if animation.name != state:
		animation.play(state)
	
