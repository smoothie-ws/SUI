#version 450

uniform sampler2D normalMap;
uniform sampler2D albedoMap;
uniform sampler2D emissionMap;
uniform sampler2D ormMap; // [occlusion, roughness, metalness, unused]

uniform vec3 lightPos;
uniform vec3 lightColor;
uniform vec2 lightAttrib; // [intensity, radius]

in vec2 fragCoord;
out vec4 fragColor;

const vec3 viewDir = vec3(0.0, 0.0, 1.0); // 2D camera
const float PI = 3.14159;

vec3 fresnelSchlick(float cosTheta, vec3 F0) {
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

float distributionGGX(vec3 N, vec3 H, float roughness) {
    float a = roughness * roughness;
    float a2 = a * a;
    float NdotH = max(dot(N, H), 0.0);
    float denom = (NdotH * (a2 - 1.0) + 1.0);
    return a2 / (PI * denom * denom);
}

float geometrySchlickGGX(float NdotX, float k) {
    return NdotX / (NdotX * (1.0 - k) + k);
}

float geometrySmith(vec3 N, vec3 V, vec3 L, float roughness) {
    float k = pow(roughness + 1.0, 2.0) / 8.0;
    return geometrySchlickGGX(max(dot(N, V), 0.0), k) *
           geometrySchlickGGX(max(dot(N, L), 0.0), k);
}

void main() {
    vec3 orm = texture(ormMap, fragCoord).rgb;
    vec3 albedo = texture(albedoMap, fragCoord).rgb;
    vec3 emission = texture(emissionMap, fragCoord).rgb;
    vec3 normal = texture(normalMap, fragCoord).rgb * 2.0 - 1.0;
    float ao = orm.r;
    float roughness = clamp(orm.g, 0.05, 1.0);
    float metalness = orm.b;
    float depth = 0.0;
    normal.z += depth;
    normal = normalize(normal);

    vec3 l = vec3(lightPos.xy - fragCoord, lightPos.z);
    float dist = length(l);
    vec3 dir = normalize(l);

    float lightAttenuation = lightAttrib.x / (4.0 * PI * dist * dist + lightAttrib.y);

    // view and half-vector
    vec3 V = normalize(viewDir);
    vec3 H = normalize(dir + V);

    // Fresnel
    vec3 F0 = mix(vec3(0.04), albedo, metalness);
    vec3 F = fresnelSchlick(max(dot(H, V), 0.0), F0);

    // BRDF components
    float NDF = distributionGGX(normal, H, roughness);
    float G = geometrySmith(normal, V, dir, roughness);
    vec3 specular = (NDF * G * F) / max(4.0 * max(dot(normal, V), 0.0) * max(dot(normal, dir), 0.0), 0.001);

    // diffuse and ambient
    vec3 kD = (1.0 - F) * (1.0 - metalness);
    vec3 diffuse = kD * albedo * max(dot(normal, dir), 0.0) / PI;

    vec3 lighting = ((diffuse * ao + specular) * lightAttenuation) * lightColor;
    fragColor = vec4(lighting + emission, 1.0);
}
