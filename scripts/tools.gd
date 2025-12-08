extends Node

# This script is just a ohandful of tools that are useful across other scripts.
# I'd love to not call it tools, feels like a bad code smell.

func flatten(vector:Vector3) -> Vector2:
	return Vector2(vector.x, vector.z)
