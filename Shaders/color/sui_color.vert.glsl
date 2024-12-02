#version 450

in vec3 vertPos;
out vec2 fragCoord;

void main() {
	gl_Position = vec4(vertPos, 1.0);
	fragCoord = vertPos.xy;
}