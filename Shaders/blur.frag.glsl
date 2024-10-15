#version 450

in vec2 texCoord;
out vec4 FragColor;

uniform sampler2D tex;
uniform float size;
uniform int quality;
uniform vec2 resolution;

void main() {
    float Pi2 = 6.28318530718; // Pi * 2
    
    float directions = 4 * quality;
    float sampleNum = quality;

    vec2 radius = size / resolution;
    vec4 col = vec4(0.0);
    float totalWeight = 0.0;

    for (float d = 0.0; d < Pi2; d += Pi2 / directions) {
        vec2 offset = vec2(cos(d), sin(d)) * radius;
        for (float i = 1.0 / sampleNum; i <= 1.0; i += 1.0 / sampleNum) {
            col += texture(tex, texCoord + offset * i) * i;
            totalWeight += i;
        }
    }

    col /= totalWeight;
    FragColor = col;
}
