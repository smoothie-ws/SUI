#version 450

in vec2 fragCoord;
out vec4 fragColor;

uniform vec2 res;
//user-defined
uniform vec4 dims;
uniform vec4 col;

void main() {
  vec2 fragCoord = fragCoord * res;
  vec2 center = dims.xy + dims.zw / 2;

  float mask = max(min(res.x, res.y) / 2 - distance(fragCoord, center), 0.0);
  
  fragColor = col * mask;
}
