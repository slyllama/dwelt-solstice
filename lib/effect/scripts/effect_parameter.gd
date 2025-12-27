class_name EffectParameter extends Resource
# Provides intransient effect data (names, icons, etc)

const _DEFAULT_TEXTURE = preload("res://lib/effect/library/textures/placeholder.png")

@export var effect_name := "((Effect))"
@export var effect_icon := _DEFAULT_TEXTURE
@export var indefinite := true
## If the same effect is re-added, its original duration will be replenished.
@export var duration_replenishes := true
