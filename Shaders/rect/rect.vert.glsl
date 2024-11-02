#version 450

in vec4 vertData;
in vec4 vertColor;
in float vertRadius;

out vec4 color;
out float radius;
out vec2 fragCoord;

void main() {
	gl_Position = vec4(vertData.x * 2 - 1, vertData.y * 2 - 1, 0.0, 1.0);
	fragCoord = vertData.zw;
	color = vertColor;
	radius = vertRadius;
}