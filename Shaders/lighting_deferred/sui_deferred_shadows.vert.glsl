#version 450

in vec2 vertPos;

void main() {
	gl_Position = vec4(vertPos, 0.0, 1.0);
}