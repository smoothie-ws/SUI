#version 450

in vec4 vertData;
in vec2 vertUV;
out vec2 fragCoord;
flat out int instanceID;

void main() {
	instanceID = int(vertData.w);
	gl_Position = vec4(vertData.xyz, 1.0);
	fragCoord = vertUV;
}