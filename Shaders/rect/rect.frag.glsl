#version 450

in vec2 fragCoord;
out vec4 fragColor;

uniform vec2 resolution;
//user-defined
uniform vec4 color;
uniform float radius;
uniform float smoothness;


void main() {
    float pSize = length(resolution);
    float cornerRadius = radius / pSize;

    vec2 dist = abs(fragCoord - 0.5) + (vec2(radius) / resolution - 0.5);

    float outside = length(max(dist, 0.0));
    float inside = min(max(dist.x, dist.y), 0.0);

    float edge = inside + outside;
    float threshold = smoothness / pSize;
    float mask = smoothstep(edge - threshold, edge + threshold, cornerRadius);

    fragColor = color * mask;
}
