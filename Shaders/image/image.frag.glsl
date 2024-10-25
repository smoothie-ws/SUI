#version 450

in vec2 fragCoord;
out vec4 fragColor;

uniform sampler2D tex;

void main() {
    fragColor = texture(tex, fragCoord);
}
