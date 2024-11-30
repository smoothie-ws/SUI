#version 450

in vec2 vertPos;
out vec2 fragCoord;

void main() {
	gl_Position = vec4(vertPos, 0.0, 1.0);
	fragCoord = vec2(vertPos.x, -vertPos.y) * 0.5 + 0.5;
}