#version 450

#define BATCH_SIZE 128

uniform vec4 uResolution;
uniform vec4 uGradBounds[BATCH_SIZE];
uniform vec4 uGradAttrib[BATCH_SIZE]; // packed values: [align_by_element, angle, offset, scale]
uniform vec4 uGradColors[BATCH_SIZE * 2];

in vec2 fragCoord;
flat in int ID;
out vec4 fragColor;

vec4 gradCol() {
    vec2 c = fragCoord * (uResolution.xy / uResolution.zw);
    if (uGradAttrib[ID][0] == 1.0) {
        c -= (uGradBounds[ID].xy - uGradBounds[ID].zw / 2) / uResolution.zw;
        c /= uGradBounds[ID].zw / uResolution.zw;
    }
    c -= uGradAttrib[ID][2];
    float m = uGradAttrib[ID][2] + uGradAttrib[ID][3] * length(c) * cos(atan(c.y, -c.x) + radians(uGradAttrib[ID][1]));
    return mix(uGradColors[ID], uGradColors[ID + 1], m);
}

void main() {
    vec2 uv = fragCoord.xy * uResolution.xy;
    float mask = float(uv.x >= uGradBounds[ID].x) * float(uv.x <= uGradBounds[ID].z) * float(uv.y >= uGradBounds[ID].y) * float(uv.x <= uGradBounds[ID].w);
    vec4 col = gradCol();
    fragColor = vec4(col.rgb, col.a * mask);
}