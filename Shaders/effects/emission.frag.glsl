#version 450

in vec2 fragCoord;
out vec4 fragColor;

uniform sampler2D tex;
uniform vec2 res;
// user-defined
uniform float size;
uniform vec2 offset;
uniform vec4 color;
uniform bool outer;
uniform int quality;

void main() {
    vec2 normOffset =  offset / res;

    float Pi2 = 6.28318530718; // Pi * 2
    
    float directions = 4 * quality;
    float sampleNum = quality;

    vec2 radius = size / res;

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

    vec4 col = texture(tex, fragCoord);
    float fOuter = float(outer);

    float outside = fOuter * alpha * (1 - col.a);
    float inside = (1 - fOuter) * (1 - alpha) * col.a;

    fragColor = mix(col, color, outside + inside);
}
