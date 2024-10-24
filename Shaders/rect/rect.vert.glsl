#version 450

in vec4 vertData; // [x, y, u, v]
out vec2 fragCoord;

void main() {
	gl_Position = vec4(vertData.x, vertData.y, 0.0, 1.0);
	fragCoord = vertData.zw / 2 + 0.5;
}