#version 450

in vec2 fragCoord;
out vec4 fragColor;

uniform vec2 res;
//user-defined
uniform vec4 dims;
uniform vec4 col;
uniform vec4 radiuses;

void main() {
    vec2 fragCoord = fragCoord * res;

    vec2 size = dims.zw;
    vec2 halfSize = size / 2;
    vec2 center = dims.xy + halfSize;

    float radius = dot(radiuses, vec4(
        float(fragCoord.x <= center.x && fragCoord.y <= center.y),
        float(fragCoord.x > center.x && fragCoord.y <= center.y),
        float(fragCoord.x <= center.x && fragCoord.y > center.y),
        float(fragCoord.x > center.x && fragCoord.y > center.y)
    ));
    radius = min(radius, min(dims.z, dims.w) / 2.0);

    vec2 q = abs(fragCoord.xy - center) - halfSize + radius;
    float mask = 1 - min(max(q.x, q.y), 0) - length(max(q, 0)) + radius;
    
    fragColor = col * mask;
}
