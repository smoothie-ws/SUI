#version 450

uniform sampler2D normalMap;
uniform sampler2D albedoMap;
uniform sampler2D ormMap; // packed values: [occlusion, roughness, metalness]

uniform vec3 lightPos;
uniform vec3 lightColor;
uniform vec2 lightAttrib; // packed values: [strength, radius]

in vec2 fragCoord;
out vec4 fragColor;

const vec3 viewDir = vec3(0.0, 0.0, 1.0); // 2d

void main() {
    vec2 uv = fragCoord.xy;

    vec3 normal = texture(normalMap, uv).rgb * 2.0 - 1.0;
    vec3 albedo = texture(albedoMap, uv).rgb;
    vec3 orm = texture(ormMap, uv).rgb;
    orm.y = pow(orm.y, 2.4);

    vec3 lightDir = vec3(lightPos.xy - uv, lightPos.z);
    
    float lightDist = length(lightDir);
    float lightAttenuation = lightAttrib.x / (1.0 + lightDist * lightDist / lightAttrib.y);

    // Lambert diffuse
    float diffuseFactor = max(dot(normal, lightDir), 0.0);
    vec3 diffuse = lightColor * albedo * diffuseFactor * orm.x * lightAttenuation;

    // Blinn-Phong specular
    vec3 halfDir = normalize(lightDir + viewDir);
    float specAngle = max(dot(normal, halfDir), 0.0);
    float specularFactor = pow(specAngle, 1.0 / (orm.y + 0.0001));
    vec3 specular = mix(lightColor, albedo, orm.z) * specularFactor;

    fragColor = vec4((1.0 - orm.z) * diffuse + specular, 1.0);
}
