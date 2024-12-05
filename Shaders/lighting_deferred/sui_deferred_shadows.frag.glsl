#version 450

in vec2 fragCoord;
in float factor;
out vec4 fragColor;

void main() {
    fragColor = vec4(1.0, 1.0, 1.0, factor);
}
