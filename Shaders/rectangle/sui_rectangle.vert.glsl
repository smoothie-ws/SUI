#version 450

#ifdef GL_ES
precision mediump float;
#endif

in vec4 vertPos;
in vec2 vertCoord;
out vec2 fragCoord;
flat out int ID;

void main() {
    ID = int(vertPos.z);
    gl_Position = vec4(vertPos.xy, 0.0, 1.0);
    fragCoord = vertCoord;
}
