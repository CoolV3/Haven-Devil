extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

@onready var label_1: Label = $"../../Label1"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var character: CharacterBody2D = $"."
var startPosition
var score = 0

func _ready() -> void:
	startPosition = character.global_position

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.is_in_group("enemies"):
			character.global_position += Vector2(500, 0)
		if collider.is_in_group("spike"):
			print("spike")
			character.global_position = startPosition
		if collider.is_in_group("coin"):
			score += 1
			collider.queue_free()
			print(score)
			label_1.text = "You did it. You got " + str(score) + " Coins!" 
			
