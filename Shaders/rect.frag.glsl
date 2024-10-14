#version 450

in vec2 coord;
out vec4 FragColor;

uniform float radius;
uniform float smoothness;
uniform vec2 resolution;
uniform vec3 color;

void main() {
    float pSize = length(resolution);
    float cornerRadius = radius / pSize;

    vec2 dist = abs(coord - 0.5) + (vec2(radius) / resolution - 0.5);

    float outside = length(max(dist, 0.0));
    float inside = min(max(dist.x, dist.y), 0.0);

    float edge = inside + outside;
    float mask = smoothstep(edge, edge + smoothness / pSize, cornerRadius);

    FragColor = vec4(color.x, color.y, color.z, 1.0) * mask;
}
