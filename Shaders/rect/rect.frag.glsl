#version 450

in vec2 fragCoord;
out vec4 fragColor;

uniform vec2 resolution;
//user-defined
uniform vec4 color;
uniform float radius;
uniform float smoothness;

void main() {
    // float pSize = length(resolution);
    // float cornerRadius = radius / min(resolution.x, resolution.y);

    // vec2 dist = abs(fragCoord - 0.5) + (vec2(radius) / resolution - 0.5);

    // float inside = min(max(dist.x, dist.y), 0.0);
    // float outside = length(max(dist, 0.0));

    // float edge = inside + outside;
    // float mask = smoothstep(edge, edge, cornerRadius);

    vec2 dist = abs(fragCoord - 0.5);
    dist.x *= resolution.y / resolution.x;
    dist.y *= resolution.x / resolution.y;

    fragColor = vec4(distance(dist, vec2(0.0)));
    fragColor.a = 1.0;
}
