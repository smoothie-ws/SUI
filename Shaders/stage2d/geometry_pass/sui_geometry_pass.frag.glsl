#version 450

uniform sampler2D albedoMap;
uniform sampler2D emissionMap;
uniform sampler2D normalMap;
uniform sampler2D ormMap;
uniform int blendMode;

in vec2 fragCoord;

layout(location = 0) out vec4 albedoColor;
layout(location = 1) out vec4 emissionColor;
layout(location = 2) out vec4 normalColor;
layout(location = 3) out vec4 ormColor;

void main() {
    albedoColor = texture(albedoMap, fragCoord);
    emissionColor = texture(emissionMap, fragCoord);
    normalColor = texture(normalMap, fragCoord);
    ormColor = texture(ormMap, fragCoord);

    int bm = blendMode;
    if (bm == 0)
        albedoColor.a = 1.0; // opaque
    else
        albedoColor.a = step(0.5, albedoColor.a); // alpha clip

    emissionColor.a = albedoColor.a;
    normalColor.a = albedoColor.a;
    ormColor.a = albedoColor.a;
}
