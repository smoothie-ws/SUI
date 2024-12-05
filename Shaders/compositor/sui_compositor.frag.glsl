#version 450

uniform sampler2D diffuseMap;
uniform sampler2D specularMap;
uniform sampler2D emissionMap;

in vec2 fragCoord;
out vec4 fragColor;

void main() {
    vec3 diffuse = texture(diffuseMap, fragCoord).rgb;
    vec3 specular = texture(specularMap, fragCoord).rgb;
    vec3 emission = texture(emissionMap, fragCoord).rgb;

    fragColor = vec4(diffuse + specular + emission, 1.0);
}
