in vec3 as_cornerTex1;
in vec3 as_cornerTex2;
flat in vec3 as_cornerTex3;

flat in int as_entityType;
flat in int as_enabled;
flat in int as_leggings;

int as_getFaceId() {
    vec2 pixelPos = vec2(texCoord0 * vec2(64, 32));

    // pixelPos += offsets[gl_VertexID % 4];

    if(pixelPos.x < 32 && pixelPos.y < 16)
        return AS_ID_HEAD;

    if(pixelPos.y >= 16 && pixelPos.y < 20) {
        if (pixelPos.x >= 4 && pixelPos.x < 12)
            return AS_ID_LEG_TOP;
        if (pixelPos.x >= 20 && pixelPos.x < 36)
            return AS_ID_TORSO_TOP;
        if (pixelPos.x >= 44 && pixelPos.x <= 52)
            return AS_ID_ARM_TOP;

    } 
    if(pixelPos.y >= 20) {

        if(pixelPos.x <= 16)
            return AS_ID_LEG_SIDES;
        if(pixelPos.x < 20)
            return AS_ID_TORSO_SIDES;
        if(pixelPos.x < 28)
            return AS_ID_TORSO_FRONT;
        if(pixelPos.x < 32)
            return AS_ID_TORSO_SIDES;
        if(pixelPos.x < 40)
            return AS_ID_TORSO_FRONT;
        if(pixelPos.x < 56)
            return AS_ID_ARM_SIDES;
    }

    return AS_ID_DEFAULT;
}

vec2 as_getCutoff(int faceId, float tightening) {
    float defaultCutoff = 10 * tightening;
    float armCutoff = 12.5 * tightening + 0.005;

    float torsoCutoffY = 12.9 * tightening;
    float torsoCutoffX = 12 * tightening + 0.005;


    switch (faceId) {
        // Left Arm Sides
        // Right Arm Sides
        case AS_ID_ARM_SIDES: 
            return vec2(defaultCutoff, armCutoff);
        // Top/Bottom Torso
        case AS_ID_TORSO_TOP:
            return vec2(torsoCutoffX, defaultCutoff);
        // Left/Right Torso
        case AS_ID_TORSO_SIDES:
            return vec2(defaultCutoff, torsoCutoffY);
        // Front/Back Torso
        case AS_ID_TORSO_FRONT:
            return vec2(torsoCutoffX, torsoCutoffY);

        case AS_ID_HEAD:
            return vec2(torsoCutoffX, torsoCutoffX);

        // Leg Sides
        case AS_ID_LEG_SIDES:
            return vec2(defaultCutoff + 0.034, armCutoff + 0.005);
        case AS_ID_LEG_TOP:
            return vec2(defaultCutoff + 0.034, defaultCutoff + 0.034);
    }

    return vec2(defaultCutoff);
}

float as_getCutoffTuning() {
    switch (as_entityType) {
        case AS_ENTITY_ZOMBIE:
            return AS_CUTOFF_ZOMBIE;
        case AS_ENTITY_HUSK:
            return AS_CUTOFF_HUSK;
    }

    return 0;
}

void as_frag() {
    int faceId = as_getFaceId();
#ifdef DEBUG_FACE
    if (faceId == DEBUG_FACE) {
        fragColor = vec4(1);
        return;
    }
#endif

    vec2 cornerUV1 = as_cornerTex1.xy / as_cornerTex1.z;
    vec2 cornerUV2 = as_cornerTex2.xy / as_cornerTex2.z;
    vec2 cornerUV3 = as_cornerTex3.xy / as_cornerTex3.z;
    vec2 minUV = min(cornerUV1, min(cornerUV2, cornerUV3));
    vec2 maxUV = max(cornerUV1, max(cornerUV2, cornerUV3));

    vec2 SamplerSize = textureSize(Sampler0, 0);

    float cutoffTuning = as_getCutoffTuning();
    vec2 cutoff = as_getCutoff(faceId, as_leggings == 1 ? tightening - 0.04 : tightening) + cutoffTuning;
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
}