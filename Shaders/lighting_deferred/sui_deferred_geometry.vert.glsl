#version 450

#define BATCH_SIZE 64

uniform int instancesCount;
uniform float zArr[BATCH_SIZE];

in vec3 vertData;
in vec2 vertUV;
flat out int instanceID;
out vec2 fragCoord;

void main() {
	instanceID = int(vertData.z);
    fragCoord = vec2(vertUV.x, (vertUV.y + instanceID) / instancesCount);
	gl_Position = vec4(vertData.xy, zArr[instanceID], 1.0);
}