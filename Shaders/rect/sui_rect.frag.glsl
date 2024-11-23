#version 450

#define BATCH_SIZE 128

uniform vec2 uResolution;
uniform vec4 uRectBounds[BATCH_SIZE];
uniform vec2 uRectAttrib[BATCH_SIZE]; // packed values: [radius, softness]
uniform vec4 uRectColors[BATCH_SIZE];

in vec2 fragCoord;
flat in int ID;
out vec4 fragColor;

float sdf(vec2 cp, vec2 si, float ra) {
    vec2 q = abs(cp) - si + ra;
    return min(max(q.x, q.y), 0) + length(max(q, 0)) - ra;
}

void main() {
    vec2 uv = fragCoord.xy * uResolution;
    vec4 bounds = uRectBounds[ID];
    bounds.z -= bounds.x; 
    bounds.w -= bounds.y;
    bounds.x += bounds.z / 2;
    bounds.y += bounds.w / 2;

    float rectDist = sdf(uv - bounds.xy, bounds.zw / 2, uRectAttrib[ID][0]);
    float rectMask = 1.0 - smoothstep(-uRectAttrib[ID][1], uRectAttrib[ID][1], rectDist);

    fragColor = vec4(uRectColors[ID].rgb, uRectColors[ID].a * rectMask);
}