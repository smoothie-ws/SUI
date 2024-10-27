#version 450

in vec2 fragCoord;
out vec4 fragColor;

uniform vec2 res;
//user-defined
uniform vec4 dims;
uniform vec4 col;
uniform float radius;

void main() {
    vec2 fragCoord = fragCoord * res;
    vec2 rectSize = dims.zw;
    vec2 halfSize = rectSize / 2;
    vec2 rectCenter = dims.xy + halfSize;
    float radius = min(radius, min(dims.z, dims.w) / 2);
    
    vec2 q = abs(fragCoord.xy - rectCenter) - halfSize + radius;
    float mask = 1 - min(max(q.x, q.y), 0) - length(max(q, 0)) + radius;
    
    fragColor = col * mask;
}
