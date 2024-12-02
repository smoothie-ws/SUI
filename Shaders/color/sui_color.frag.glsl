#version 450

in vec2 fragCoord;
out vec4 fragColor;

uniform vec4 col;

void main() {
    fragColor = col;
}
