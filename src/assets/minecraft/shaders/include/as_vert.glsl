out vec3 as_cornerTex1;
out vec3 as_cornerTex2;
flat out vec3 as_cornerTex3;

flat out int as_entityType;
flat out int as_enabled;
flat out int as_leggings;

int as_isEnabled() {
    vec4 marker = texture(Sampler0, vec2(0, 0)) * 255;

    return (marker.r == 42 && marker.g == 42 && marker.b == 42 && marker.a == 5) ? 1 : 0;
}

int as_getEntityType() {
    vec4 entityType = texture(Sampler0, vec2(1, 0) / textureSize(Sampler0, 0)) * 255;

    return int(entityType.r);
}

int as_isLeggings() {
    vec4 isLeggings = texture(Sampler0, vec2(2, 0) / textureSize(Sampler0, 0)) * 255;

    return isLeggings.a != 0 ? 1 : 0;
}

bool as_vert() {
    as_enabled = as_isEnabled();
    as_entityType = AS_ENTITY_ZOMBIE;
    as_leggings = 0;

    if (as_enabled == 0) {
        return false;
    }

    as_leggings = as_isLeggings();
    as_entityType = as_getEntityType();
 
    // Output the edges of the UV coordinates to know where the character is (credits to Bálint)
    as_cornerTex1 = vec3(0);
    as_cornerTex2 = vec3(0);
    as_cornerTex3 = vec3(0);
    if(gl_VertexID % 4 == 0)
        as_cornerTex1 = vec3(UV0, 1);
    if(gl_VertexID % 4 == 2)
        as_cornerTex2 = vec3(UV0, 1);
    if(gl_VertexID % 2 == 1)
        as_cornerTex3 = vec3(UV0, 1);

    float offset = tightening;

    if (as_leggings == 1)
        offset -= 0.04;

    vec3 pos = Position - Normal * offset;

    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
    vertexDistance = fog_distance(pos, FogShape);

    return true;
}