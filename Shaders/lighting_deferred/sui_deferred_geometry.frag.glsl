#version 450

#define BATCH_SIZE 64

uniform sampler2D albedoMap;
uniform sampler2D emissionMap;
uniform sampler2D normalMap;
uniform sampler2D ormMap;
uniform int instancesCount;
uniform int blendModes[BATCH_SIZE];

in vec2 fragCoord;
flat in int instanceID;

layout(location = 0) out vec4 albedoColor;
layout(location = 1) out vec4 emissionColor;
layout(location = 2) out vec4 normalColor;
layout(location = 3) out vec4 ormColor;

void main() {
    vec2 uv = vec2(fragCoord.x, (fragCoord.y + instanceID) / instancesCount);

    albedoColor = texture(albedoMap, uv);
    emissionColor = texture(emissionMap, uv);
    normalColor = texture(normalMap, uv);
    ormColor = texture(ormMap, uv);

    int bm = blendModes[instanceID];
    if (bm == 0)
        albedoColor.a = 1.0; // opaque
    else if (bm == 1)
        albedoColor.a = step(0.5, albedoColor.a); // alpha clip
    // else if (bm == 2) -> alpha blend (no need to change anything)

    emissionColor.a = albedoColor.a;
    normalColor.a = albedoColor.a;
    ormColor.a = albedoColor.a;
}
