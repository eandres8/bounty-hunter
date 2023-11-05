extends CharacterBody2D
class_name Player

const SPEED := 80;
var is_on_attack := false

@onready var screensize = get_viewport_rect().size


func _process(_delta):
	anim_ctrl()
	motion_ctrl()
	attack_soft()


func anim_ctrl() -> void:
	var AXIS_X = GLOBAL.get_axis().x;
	var AXIS_Y = GLOBAL.get_axis().y;
	
	if !is_on_attack:
		if AXIS_X != 0 or AXIS_Y != 0:
			$Body.play("Walk")
		else:
			$Body.play("Idle")
		
	$Body.flip_h = AXIS_X < 0 if AXIS_X != 0 else $Body.flip_h


func motion_ctrl() -> void:
	if !is_on_attack:
		velocity.x = GLOBAL.get_axis().x * SPEED
		velocity.y = GLOBAL.get_axis().y * -SPEED
		
		move_and_slide()
	
		position.x = clamp(position.x, 0, screensize.x)
		position.y = clamp(position.y, 0, screensize.y)


func attack_soft() -> void:
	if Input.is_action_just_pressed("attack_soft"):
		is_on_attack = true
		$Body.play("Attack_Soft")
		$Settings/Hit.play()
		await ($Body.animation_finished)
		is_on_attack = false
		
