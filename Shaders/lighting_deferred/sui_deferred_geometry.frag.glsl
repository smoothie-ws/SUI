#version 450

uniform sampler2D albedoMap;
uniform sampler2D emissionMap;
uniform sampler2D normalMap;
uniform sampler2D ormMap;
uniform int instancesCount;

in vec2 fragCoord;
flat in int instanceID;

layout(location = 0) out vec4 albedoColor;
layout(location = 1) out vec4 emissionColor;
layout(location = 2) out vec4 normalColor;
layout(location = 3) out vec4 ormColor;

vec4 linearize(vec4 col) {
    return vec4(
        pow(col.r, 1 / 1.98),
        pow(col.g, 1 / 1.98),
        pow(col.b, 1 / 1.98),
        pow(col.a, 1 / 1.98)
    );
}

void main() {
    vec2 uv = vec2(fragCoord.x, (fragCoord.y + instanceID) / instancesCount);

    albedoColor = linearize(texture(albedoMap, uv));
    emissionColor = linearize(texture(emissionMap, uv));
    normalColor = linearize(texture(normalMap, uv));
    ormColor = linearize(texture(ormMap, uv));
}
