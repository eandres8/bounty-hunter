extends CharacterBody2D

enum States { IDLE, RUN, DAMAGE, DIE }

const SPEED := 70
var life := 100
var _state := States.IDLE

func _ready():
	velocity.x = -SPEED
	_state = States.RUN

func _process(_delta):
	_state_matching()
	move_and_slide()

func _state_matching():
	match _state:
		States.IDLE:
			idle_action()
		States.RUN:
			run_action()
		States.DAMAGE:
			damage_action()
		States.DIE:
			die_action()

func make_damage(damage) -> void:
	var new_life = life - damage
	
	if new_life < life:
		if new_life > 0:
			life = new_life
			_state = States.DAMAGE
		else:
			life = 0
			_state = States.DIE
			

func idle_action():
	$Body.play("Idle")

func run_action():
	if is_on_wall():
		_state = States.IDLE
	else:
		$Body.play("Run")

func damage_action():
	$Body.play("Damage")

func die_action():
	$Body.play("Died")

func _on_body_animation_finished():
	if $Body.animation == "Damage":
		_state = States.IDLE
	
	if $Body.animation == "Died":
		set_process(false)
		queue_free()
