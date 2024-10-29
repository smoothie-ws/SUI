#version 450

in vec2 fragCoord;
out vec4 fragColor;

uniform vec2 res;
uniform sampler2D tex;
// user-defined
uniform float size;
uniform int quality;
uniform bool masked;
uniform sampler2D mask;

const float Pi2 = 6.28318530718; // Pi * 2

void main() {
    float sampleNum = quality;

    vec2 radius = size / res;
    vec4 col = vec4(0.0);
    float weight = 0.0;

    float alphaMask = smoothstep(0.1, 0.2, texture(mask, fragCoord).a);
    for (float d = 0.0; d < Pi2; d += Pi2 / quality / 4) {
        vec2 offset = vec2(cos(d), sin(d)) * radius * alphaMask;
        for (float i = 1.0 / sampleNum; i <= 1.0; i += 1.0 / sampleNum) {
            vec4 sampleColor = texture(tex, fragCoord + offset * i);
            sampleColor.rgb *= sampleColor.a;
            col += sampleColor * i;
            weight += i;
        }
    }

    col /= weight;
    col.rgb /= col.a;
    fragColor = col;
}
