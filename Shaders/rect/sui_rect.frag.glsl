#version 450

#define BATCH_SIZE 64

uniform vec4 uResolution;
uniform vec4 uRectRadius[BATCH_SIZE];
uniform vec4 uRectBounds[BATCH_SIZE];
uniform float uRectSoftness[BATCH_SIZE];
uniform vec4 uGradColors[BATCH_SIZE * 2];
uniform vec4 uGradAttrib[BATCH_SIZE]; // [align_by_element, angle, offset, scale]

in vec2 fragCoord;
flat in int ID;
out vec4 fragColor;

float sdf(vec2 cp, vec2 si, vec4 ra) {
    ra.xy = cp.x > 0 ? ra.xy : ra.zw;
    ra.x  = cp.y > 0 ? ra.x : ra.y;

    vec2 q = abs(cp) - si + ra.x;
    return min(max(q.x, q.y), 0) + length(max(q, 0)) - ra.x;
}

vec4 gradCol() {
    vec2 c = fragCoord * (uResolution.xy / uResolution.zw);
    if (uGradAttrib[ID][0] == 1.0) {
        c -= (uRectBounds[ID].xy - uRectBounds[ID].zw / 2) / uResolution.zw;
        c /= uRectBounds[ID].zw / uResolution.zw;
    }
    c -= uGradAttrib[ID][2];
    float m = uGradAttrib[ID][2] + uGradAttrib[ID][3] * length(c) * cos(atan(c.y, -c.x) + radians(uGradAttrib[ID][1]));
    return mix(uGradColors[ID], uGradColors[ID + 1], m);
}

void main() {
    vec2 uv = fragCoord.xy * uResolution.xy;

    vec2 cp = uv - uRectBounds[ID].xy;
    vec2 si = uRectBounds[ID].zw / 2;

    float rectDist = sdf(cp, si, uRectRadius[ID]);
    float rectMask = 1.0 - smoothstep(-uRectSoftness[ID], uRectSoftness[ID], rectDist);

    vec4 col = gradCol();
    fragColor = vec4(col.rgb, col.a * rectMask);
}