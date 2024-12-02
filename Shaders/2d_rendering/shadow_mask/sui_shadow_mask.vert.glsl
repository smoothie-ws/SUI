#version 450

in vec3 vertData;
out vec2 fragCoord;
out float factor;

void main() {
	gl_Position = vec4(vertData.xy, 0.0, 1.0);
	fragCoord = vertData.xy * 0.5 + 0.5;
	factor = vertData.z;
}