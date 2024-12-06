#version 450

in vec4 vertData;
in vec2 vertUV;
flat out int instanceID;
out vec2 fragCoord;

void main() {
	fragCoord = vertUV;
	instanceID = int(vertData.w);
	gl_Position = vec4(vertData.xyz, 1.0);
}