#version 450

#define BATCH_SIZE 64

uniform ivec2 uResolution;
uniform float uOpacity[BATCH_SIZE];
uniform vec4 uRectRadius[BATCH_SIZE];
uniform vec4 uRectBounds[BATCH_SIZE];
uniform vec4 uRectColor[BATCH_SIZE];
uniform float uRectSoftness[BATCH_SIZE];
uniform vec4 uBordColor[BATCH_SIZE];
uniform float uBordSoftness[BATCH_SIZE];
uniform float uBordThickness[BATCH_SIZE];
uniform vec4 uEmisColor[BATCH_SIZE];
uniform vec2 uEmisOffset[BATCH_SIZE];
uniform float uEmisSize[BATCH_SIZE];
uniform float uEmisSoftness[BATCH_SIZE];
uniform vec4 uGradColors[BATCH_SIZE * 2];
uniform vec4 uGradAttrib[BATCH_SIZE]; // [use_grad, angle, offset, scale]

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
    float o = 0.5 - uGradAttrib[ID][1];
    vec2 c = fragCoord - o;
    float m = o + uGradAttrib[ID][2] * length(c) * cos(atan(c.y, -c.x) + uGradAttrib[ID][0]);
    return mix(uGradColors[ID], uGradColors[ID + 1], m);
}

void main() {
    vec2 uv = fragCoord.xy * uResolution;

    vec2 cp = uv - uRectBounds[ID].xy;
    vec2 si = uRectBounds[ID].zw / 2;

    float rectDist = sdf(cp, si, uRectRadius[ID]);
    float emisDist = sdf(cp - uEmisOffset[ID], si, uRectRadius[ID]);

    float emisMask = smoothstep(-uEmisSoftness[ID], uEmisSoftness[ID], emisDist - uEmisSize[ID]);
    float bordMask = smoothstep(uBordThickness[ID] - uBordSoftness[ID], uBordThickness[ID] + uBordSoftness[ID], abs(rectDist));
    float rectMask = smoothstep(-uRectSoftness[ID], uRectSoftness[ID], rectDist);

    fragColor = vec4(0.0);
    fragColor = mix(uEmisColor[ID], fragColor, emisMask);
    if (uGradAttrib[ID][0] == 0.0) 
        fragColor = mix(uRectColor[ID], fragColor, rectMask);
    else 
        fragColor = mix(gradCol(), fragColor, rectMask);
    fragColor = mix(uBordColor[ID], fragColor, bordMask);
    fragColor.a *= uOpacity[ID];
}