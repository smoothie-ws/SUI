#version 450

in vec2 fragCoord;
out vec4 fragColor;

uniform vec2 resolution;
//user-defined
uniform vec4 color;
uniform float smoothness;

void main() {
    float pSize = length(resolution);

    float threshold = smoothness / pSize;
    float mask = smoothstep(0.5 - threshold, 0.5 + threshold, 1 - distance(fragCoord, vec2(0.5)));

    fragColor = color * mask;
}
