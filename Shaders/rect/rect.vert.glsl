#version 450

#define BATCH_SIZE 64

uniform vec4 uScale[BATCH_SIZE];
uniform vec3 uRotation[BATCH_SIZE];

in vec3 vertPos;
flat out int ID;
out vec2 fragCoord;

vec2 rotate(vec2 c, vec2 o, float a) {
    mat2 r = mat2(
      cos(a), -sin(a),
      sin(a),  cos(a)
    );
    return (c - o) * r + o;
}

vec2 scale(vec2 c, vec2 o, vec2 s) {
    return (c - o) * s + o;
}

vec2 transform(vec2 c, vec4 s, vec3 r) {
    return scale(rotate(c, r.xy, r.z), s.xy, s.zw);
}

void main() {
    ID = int(vertPos.z);
    vec2 pos = transform(vertPos.xy, uScale[ID], uRotation[ID]);

    gl_Position = vec4(pos, 0.0, 1.0);
    fragCoord = vertPos.xy * 0.5 + 0.5;
}
