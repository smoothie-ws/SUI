#version 450

in vec2 vertPos;
out vec2 fragCoord;

void main() {
	fragCoord = vertPos / 2 + 0.5;
	gl_Position = vec4(vertPos, 0.0, 1.0);
}