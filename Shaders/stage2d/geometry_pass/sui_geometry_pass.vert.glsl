#version 450

in vec3 vertPos;
in vec2 vertUV;
out vec2 fragCoord;

void main() {
    fragCoord = vertUV;
	gl_Position = vec4(vertPos, 1.0);
}