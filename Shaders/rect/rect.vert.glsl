#version 450

in vec2 vertPos;
out vec2 fragCoord;

void main() {
	gl_Position = vec4(vertPos.x, vertPos.y, 0.0, 1.0);
	fragCoord = vertPos.xy / 2 + 0.5;
}