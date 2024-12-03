#version 450

uniform sampler2D gMaps;
uniform int gMapsCount;

in vec2 fragCoord;
flat in int UID;
out vec4 fragColor;

void main() {
    vec2 uv = vec2(fragCoord.x / 4, fragCoord.y * (UID / gMapsCount));
    fragColor = texture(gMaps, uv);
}
