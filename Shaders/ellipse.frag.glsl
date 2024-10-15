#version 450

in vec2 fragCoord;
out vec4 FragColor;

uniform vec4 color;
uniform vec2 resolution;
uniform float smoothness;

void main() {
    float pSize = length(resolution);

    float threshold = smoothness / pSize;
    float mask = smoothstep(0.5 - threshold, 0.5 + threshold, 1 - distance(fragCoord, vec2(0.5)));

    FragColor = vec4(color.x, color.y, color.z, color.w * mask);
}
