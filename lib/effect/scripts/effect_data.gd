class_name EffectData extends Resource

@export var id := "effect"
@export var duration := 5.0 # only applies if not indefinite

var remaining_time := duration

signal expired
