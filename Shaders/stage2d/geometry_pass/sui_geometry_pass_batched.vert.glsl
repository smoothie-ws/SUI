#version 450

uniform int instancesCount;

in vec4 vertData;
in vec2 vertUV;
out vec2 fragCoord;
flat out int instanceID;

void main() {
	instanceID = int(vertData.w);
    fragCoord = vec2(vertUV.x, (vertUV.y + instanceID) / instancesCount);
	gl_Position = vec4(vertData.xyz, 1.0);
}