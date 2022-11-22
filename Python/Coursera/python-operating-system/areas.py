import math

def triangle(base, height):
	return base*height/2

def rectangle(base, height):
	return base*height

def circle(radius):
	return math.pi*(radius**2)

def donut(outside_radius, inside_radius):
	return circle(outside_radius) - circle(inside_radius)
