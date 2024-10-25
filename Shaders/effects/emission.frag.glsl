#version 450

in vec2 fragCoord;
out vec4 FragColor;

uniform sampler2D tex;
uniform vec2 resolution;
// user-defined
uniform float size;
uniform vec2 offset;
uniform vec4 color;
uniform bool outer;
uniform int quality;


void main() {
    vec2 normOffset =  offset / resolution;

    float Pi2 = 6.28318530718; // Pi * 2
    
    float directions = 4 * quality;
    float sampleNum = quality;

    vec2 radius = size / resolution;

    float alpha = 0.0;
    float weight = 0.0;

    for (float d = 0.0; d < Pi2; d += Pi2 / directions) {
        vec2 sampleOffset = vec2(cos(d), sin(d)) * radius;
        for (float i = 1.0 / sampleNum; i <= 1.0; i += 1.0 / sampleNum) {
            float sampleAlpha = texture(tex, fragCoord - normOffset + sampleOffset * i).a;
            alpha += sampleAlpha * i;
            weight += i;
        }
    }

    alpha /= weight;
    FragColor = vec4(color.r, color.g, color.b, alpha);

    vec4 col = texture(tex, fragCoord);
    FragColor = mix(FragColor, col, col.a);
}
