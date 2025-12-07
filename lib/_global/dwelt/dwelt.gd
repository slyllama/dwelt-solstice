extends Node

const GRAVITY := -9.8

signal window_adjusted # called when retina is detected

# References
var camera: Camera3D
var player: CharacterBody3D
