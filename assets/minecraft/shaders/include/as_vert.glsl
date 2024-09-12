out vec3 cornerTex1;
out vec3 cornerTex2;
flat out vec3 cornerTex3;

bool isShrink() {
    vec4 marker = texture(Sampler0, vec2(0, 0)) * 255;

    return marker.r == 42 && marker.g == 42 && marker.b == 42 && marker.a == 5; 
}

void vert() {
    // Output the edges of the UV coordinates to know where the character is (credits to Bálint)
    cornerTex1 = vec3(0);
    cornerTex2 = vec3(0);
    cornerTex3 = vec3(0);
    if(gl_VertexID % 4 == 0)
        cornerTex1 = vec3(UV0, 1);
    if(gl_VertexID % 4 == 2)
        cornerTex2 = vec3(UV0, 1);
    if(gl_VertexID % 2 == 1)
        cornerTex3 = vec3(UV0, 1);

    float offset = tightening;

    vec3 pos = Position - Normal * offset;

    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
    vertexDistance = fog_distance(pos, FogShape);
}