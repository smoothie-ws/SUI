#version 450

in vec2 fragCoord;
out vec4 fragColor;

uniform sampler2D tex;
uniform vec2 resolution;
// user-defined
uniform float size;
uniform int quality;

void main() {
    float Pi2 = 6.28318530718; // Pi * 2
    
    float directions = 4 * quality;
    float sampleNum = quality;

    vec2 radius = size / resolution;
    vec4 col = vec4(0.0);
    float weight = 0.0;

    for (float d = 0.0; d < Pi2; d += Pi2 / directions) {
        vec2 offset = vec2(cos(d), sin(d)) * radius;
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
