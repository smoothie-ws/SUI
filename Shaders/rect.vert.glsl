#version 450

in vec3 pos;
out vec2 coord;

void main() {
	gl_Position = vec4(pos.x, pos.y, pos.z, 1.0);
	coord = vec2(1 + pos.x, 1 - pos.y) / 2;
}