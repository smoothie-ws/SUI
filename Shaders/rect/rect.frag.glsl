#version 450

in vec2 fragCoord;
in vec4 color;
in float radius;
out vec4 fragColor;

void main() {
    vec2 d = abs(fragCoord - 0.5) - 0.5 + radius;
    fragColor = color * float(length(max(d, 0.0)) - radius < 0.0);
}
