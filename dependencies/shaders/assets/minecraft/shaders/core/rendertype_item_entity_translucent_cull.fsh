#version 150

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightColor;
in vec2 texCoord0;
in vec2 texCoord1;

out vec4 fragColor;

bool shouldShade() {
    return abs(vertexColor.r * 255.0 - 1) < 0.5 &&
        abs(vertexColor.g * 255.0 - 1) < 0.5 &&
        abs(vertexColor.b * 255.0 - 254) < 0.5;
}

void main() {
    vec4 color;

    if(shouldShade()) {

        color = texture(Sampler0, texCoord0);

        if(color.a < 0.1) {
            discard;
        }
        
        fragColor = color;

        return;
    } else {

        color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator * lightColor;
    }

    if(color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}