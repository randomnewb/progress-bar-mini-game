extends CharacterBody2D

@export var speed = 100;
@onready var ray_cast_2d = $RayCast2D
var last_clicked_position = null;
var interacting = false;
var interacting_object = null;
var collision = null;
var CONTROL_PROGRESS_SCENE = preload("res://UI/control_progress.tscn")

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

signal mini_game_won

func _process(delta):
	if not interacting:
		var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")

		if Input.is_action_pressed("tap_left_mouse"):
			last_clicked_position = get_local_mouse_position();
			var target = last_clicked_position;
			target /= position;
			input_vector = target.normalized();

		if input_vector == Vector2.ZERO:
	#		animation_player.play("idle");
			pass;
		else:
	#		animation_player.play("run");
			if input_vector.x != 0:
				sprite_2d.scale.x = 0.1 * sign(input_vector.x);
	#	position.x = clamp(position.x, 5, width - 5);
	#	position.y = clamp(position.y, 5, height - 5);
		#position += input_vector * speed * delta;
		
		#ray_cast code
	#	ray_cast_2d.target_position = input_vector * 25;
	#	var ray_collide = ray_cast_2d.get_collider()
	#	if ray_collide:
	#		print("ray: ",ray_collide)
		
		collision = move_and_collide(input_vector * speed * delta);
	
	if collision and not interacting:
		interacting = true;
#		print("collision ", collision.get_collider().name)
		interacting_object = collision.get_collider()
		var control_progress_scene = CONTROL_PROGRESS_SCENE.instantiate();
		var world = get_tree().current_scene;
		world.add_child.call_deferred(control_progress_scene);
		control_progress_scene.scale.x = 0.2
		control_progress_scene.scale.y = 0.4
		control_progress_scene.position = global_position;
		#other_instance.signal_that_other_instance_is_emitting.connect(to_the_current_object_probably._on_currentObject_name_of_signal)
		control_progress_scene.mini_game_completed.connect(self._on_player_mini_game_completed);

func _on_player_mini_game_completed():
	animation_player.play("swing");
	await get_tree().create_timer(1.0).timeout;
	interacting_object.queue_free();
	mini_game_won.emit();
	interacting = false;
	animation_player.play("RESET");
