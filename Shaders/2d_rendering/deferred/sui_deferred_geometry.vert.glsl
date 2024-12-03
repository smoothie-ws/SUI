#version 450

in vec4 vertData;
in vec2 vertUV;
flat out int UID;
out vec2 fragCoord;

void main() {
	UID = int(vertData.w);
	fragCoord = vertUV;
	gl_Position = vec4(vertData.xyz, 1.0);
}