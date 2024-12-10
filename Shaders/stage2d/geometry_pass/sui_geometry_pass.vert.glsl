#version 450

in vec4 vertData;
in vec2 vertUV;
out vec2 fragCoord;

void main() {
    fragCoord = vertUV;
	gl_Position = vec4(vertData.xyz, 1.0);
}