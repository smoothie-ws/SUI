#version 450

uniform vec2 lightPos;
uniform vec3 lightCol;
uniform float lightStrength;
uniform float lightAccumulation;

in vec2 fragCoord;
out vec4 fragColor;

void main() {
    float dist = distance(fragCoord, lightPos);
    float lightMask = exp(-pow(dist, lightAccumulation)) * lightStrength - 1;

    vec3 finalColor = lightCol * lightMask;
    fragColor = vec4(finalColor, 1.0);
}
