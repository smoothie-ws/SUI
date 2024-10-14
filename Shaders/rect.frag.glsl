#version 450

in vec2 coord;
out vec4 FragColor;

uniform vec4 dims;
uniform vec3 color;
uniform float radius;
uniform float smoothness;
uniform vec2 resolution;

void main() {
    vec2 uv = coord * resolution;
    
    float x = dims[0];
    float y = dims[1];
    float w = dims[2];
    float h = dims[3];

    vec2 rectCenter = vec2(x + w / 2.0, y + h / 2.0);

    vec2 rectSize = vec2(w, h) / 2.0 - vec2(radius);
    vec2 dist = abs(uv - rectCenter) - rectSize;

    float outside = length(max(dist, 0.0));
    float inside = min(max(dist.x, dist.y), 0.0);

    float edge = inside + outside;
    float mask = smoothstep(edge, edge + smoothness, radius);

    FragColor = vec4(color.x, color.y, color.z, 1.0) * mask;
}
