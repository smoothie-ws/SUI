#version 450

in vec2 coord;
out vec4 FragColor;

uniform float x;
uniform float y;
uniform float width;
uniform float height;
uniform vec3 color;
uniform float radius;
uniform float smoothness;
uniform vec2 resolution;

void main() {
    vec2 uv = coord * resolution;
    vec2 rectCenter = vec2(x + width / 2.0, y + height / 2.0);

    vec2 rectSize = vec2(width, height) / 2.0 - vec2(radius);
    vec2 dist = abs(uv - rectCenter) - rectSize;

    float outside = length(max(dist, 0.0));
    float inside = min(max(dist.x, dist.y), 0.0);

    float edge = inside + outside;
    float mask = smoothstep(edge, edge + smoothness, radius);

    FragColor = vec4(color.x, color.y, color.z, 1.0) * mask;
}
