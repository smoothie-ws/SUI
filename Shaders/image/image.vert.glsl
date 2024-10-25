#version 450

in vec2 vertCoord;
out vec2 fragCoord;

void main() {
	gl_Position = vec4(vertCoord.x, vertCoord.y, 0.0, 1.0);
	fragCoord = (vertCoord + 1) / 2;
}