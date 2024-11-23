#version 450

#ifdef GL_ES
precision mediump float;
#endif

in vec3 vertPos;
out vec2 fragCoord;
flat out int ID;

void main() {
    ID = int(vertPos.z);
    gl_Position = vec4(vertPos.xy, 0.0, 1.0);
    fragCoord = vec2(vertPos.x, vertPos.y) * 0.5 + 0.5;
}
