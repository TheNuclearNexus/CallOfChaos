#version 150

#moj_import <fog.glsl>

#define AS_FRAG
#moj_import <armor_shrink.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;
in vec4 normal;

// flat in int faceId;

out vec4 fragColor;

const float cutoffTuning = 0.04;

const float defaultCutoff = 10 * tightening;
const float armCutoff = 12.5 * tightening + 0.005;

const float torsoCutoffY = 12.9 * tightening;
const float torsoCutoffX = 12 * tightening + 0.005;

int getFaceId() {
    vec2 pixelPos = vec2(texCoord0 * vec2(64, 32));

    // pixelPos += offsets[gl_VertexID % 4];

    if(pixelPos.x < 32 && pixelPos.y < 16)
        return HEAD;

    if(pixelPos.y >= 16 && pixelPos.y < 20) {
        if (pixelPos.x >= 4 && pixelPos.x < 12)
            return LEG_TOP;
        if (pixelPos.x >= 20 && pixelPos.x < 36)
            return TORSO_TOP;
        if (pixelPos.x >= 44 && pixelPos.x <= 52)
            return ARM_TOP;

    } 
    if(pixelPos.y >= 20) {

        if(pixelPos.x <= 16)
            return LEG_SIDES;
        if(pixelPos.x < 20)
            return TORSO_SIDES;
        if(pixelPos.x < 28)
            return TORSO_FRONT;
        if(pixelPos.x < 32)
            return TORSO_SIDES;
        if(pixelPos.x < 40)
            return TORSO_FRONT;
        if(pixelPos.x < 56)
            return ARM_SIDES;
    }

    return DEFAULT;
}

vec2 getCutoff(int faceId) {

    switch (faceId) {
        // Left Arm Sides
        // Right Arm Sides
        case ARM_SIDES: 
            return vec2(defaultCutoff, armCutoff);
        // Top/Bottom Torso
        case TORSO_TOP:
            return vec2(torsoCutoffX, defaultCutoff);
        // Left/Right Torso
        case TORSO_SIDES:
            return vec2(defaultCutoff, torsoCutoffY);
        // Front/Back Torso
        case TORSO_FRONT:
            return vec2(torsoCutoffX, torsoCutoffY);

        case HEAD:
            return vec2(torsoCutoffX, torsoCutoffX);

    }

    return vec2(defaultCutoff);
}

// #define DEBUG_FACE 1

void main() {

    int faceId = getFaceId();
#ifdef DEBUG_FACE
    if (faceId == DEBUG_FACE) {
        fragColor = vec4(1);
        return;
    }
#endif

    vec2 cornerUV1 = cornerTex1.xy / cornerTex1.z;
    vec2 cornerUV2 = cornerTex2.xy / cornerTex2.z;
    vec2 cornerUV3 = cornerTex3.xy / cornerTex3.z;
    vec2 minUV = min(cornerUV1, min(cornerUV2, cornerUV3));
    vec2 maxUV = max(cornerUV1, max(cornerUV2, cornerUV3));

    vec2 SamplerSize = textureSize(Sampler0, 0);
    vec2 cutoff = getCutoff(faceId) + cutoffTuning;
    vec2 minUVNew = minUV + cutoff / SamplerSize;
    vec2 maxUVNew = maxUV - cutoff / SamplerSize;

    vec2 t = (texCoord0 - minUVNew) / (maxUVNew - minUVNew);
    if(t.x < 0.0 || 1.0 < t.x || t.y < 0.0 || 1.0 < t.y)
        discard;
    vec2 UV = mix(minUV, maxUV, t);

    vec4 color = texture(Sampler0, UV) * vertexColor * ColorModulator;
    if(color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
    // fragColor = vec4(faceId / 16.0, 0, 0, 1);
}
