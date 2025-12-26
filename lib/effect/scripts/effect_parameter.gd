class_name EffectParameter extends Resource
# Provides intransient effect data (names, icons, etc)

@export var effect_name := "((Effect))"
@export var indefinite := true
## If the same effect is re-added, its original duration will be replenished.
@export var duration_replenishes := true
