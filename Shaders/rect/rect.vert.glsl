#version 450

#define BATCH_SIZE 64

uniform vec2 uTransformOrigin[BATCH_SIZE];
uniform vec3 uScaleRotation[BATCH_SIZE];

in vec3 vertPos;
out vec2 fragCoord;
flat out int ID;

vec2 transform(vec2 c, vec2 o, vec3 sr) {
    mat2 r = mat2(
      cos(sr.z), -sin(sr.z),
      sin(sr.z),  cos(sr.z)
    );
    return (c + o) * r * sr.xy - o;
}

void main() {
    ID = int(vertPos.z);
    vec2 coord = transform(vertPos.xy, uTransformOrigin[ID], uScaleRotation[ID]);

    gl_Position = vec4(coord, 0.0, 1.0);
    fragCoord = vertPos.xy * 0.5 + 0.5;
}
