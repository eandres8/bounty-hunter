extends CanvasLayer

@onready var _label := %Label as Label;
@onready var _health := %Health as TextureRect;

func _process(delta):
	_label.text = str(GLOBAL.score)
	var health = (GLOBAL.life * 55) / 100
	_health.set_size(Vector2(health, 10))
	
