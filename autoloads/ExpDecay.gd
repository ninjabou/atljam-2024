extends Node

func expDecay(a, b, decay, delta):
	return b + (a - b) * exp(-decay * delta)
