shader_type spatial;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform vec3 wave_a = vec3(1.0, 0.4, 10.0);
uniform vec2 wave_a_dir = vec2(1.0, 0.0);
uniform vec3 wave_b = vec3(1.0, 0.25, 20.0);
uniform vec2 wave_b_dir = vec2(1.0, 1.0);
uniform vec3 wave_c = vec3(1.0, 0.15, 1.0);
uniform vec2 wave_c_dir = vec2(1.0, 0.5);
uniform float time;
uniform float height_scale = 1.0;
uniform float beer_factor = 0.8;
varying vec3 v_normal;
varying float wave_height;
uniform vec4 _DepthGradientShallow: source_color = vec4(0.325, 0.807, 0.971, 0.725);
uniform vec4 _DepthGradientDeep: source_color = vec4(0.086, 0.407, 1, 0.749);
uniform float _DepthMaxDistance: hint_range(0, 1) = 1.0;
uniform float _DepthFactor = 1.0;

vec3 gerstnerWave(vec3 wave, vec2 wave_dir, vec3 p, float t) {
    float amplitude = wave.x;
    float steepness = wave.y;
    float wavelength = wave.z;
    float k = 2.0 * PI / wavelength;
    float c = sqrt(9.8 / k);
    vec2 d = normalize(wave_dir);
    float f = k * (dot(d, p.xz) - (c * t));
    float a = steepness / k;
    return vec3(d.x * (a * cos(f)), amplitude * a * sin(f), d.y * (a * cos(f)));
}

void computeGerstnerNormal(in vec3 wave, in vec2 wave_dir, in vec3 p, float t, inout vec3 tangent, inout vec3 binormal) {
    float amplitude = wave.x;
    float steepness = wave.y;
    float wavelength = wave.z;
    float k = 2.0 * PI / wavelength;
    float c = sqrt(9.8 / k);
    vec2 d = normalize(wave_dir);
    float f = k * (dot(d, p.xz) - (c * t));
    float a = steepness / k;
    tangent += normalize(vec3(1.0 - d.x * d.x * steepness * sin(f), d.x * steepness * cos(f), -d.x * d.y * (steepness * sin(f))));
    binormal += normalize(vec3(-d.x * d.y * (steepness * sin(f)), d.y * steepness * cos(f), 1.0 - (d.y * d.y * steepness * sin(f))));
}

vec4 alphaBlend(vec4 top, vec4 bottom) {
    vec3 color = (top.rgb * top.a) + (bottom.rgb * (1.0 - top.a));
    float alpha = top.a + bottom.a * (1.0 - top.a);
    return vec4(color, alpha);
}


void vertex() {
    vec3 original_p = (MODEL_MATRIX * vec4(VERTEX.xyz, 1.0)).xyz;
    vec3 displacement = vec3(0.0);
    vec3 tangent = vec3(1.0, 0.0, 0.0);
    vec3 binormal = vec3(0.0, 0.0, 1.0);

    displacement += gerstnerWave(wave_a, wave_a_dir, original_p, time / 2.0);
    computeGerstnerNormal(wave_a, wave_a_dir, original_p, time / 2.0, tangent, binormal);
    
    displacement += gerstnerWave(wave_b, wave_b_dir, original_p, time / 2.0);
    computeGerstnerNormal(wave_b, wave_b_dir, original_p, time / 2.0, tangent, binormal);
    
    displacement += gerstnerWave(wave_c, wave_c_dir, original_p, time / 2.0);
    computeGerstnerNormal(wave_c, wave_c_dir, original_p, time / 2.0, tangent, binormal);

    VERTEX.y += height_scale * displacement.y;
    vec3 normal = normalize(cross(binormal, tangent));
    v_normal = normal;
    wave_height = VERTEX.y;
}

void fragment() {
    float depthVal = texture(DEPTH_TEXTURE, SCREEN_UV).r;
    float depth = PROJECTION_MATRIX[3][2] / (depthVal + PROJECTION_MATRIX[2][2]);
    depth = depth + VERTEX.z;
    depth = exp(-depth * beer_factor);
    depth = 1.0 - depth;

    float waterDepth = clamp(depth / _DepthMaxDistance, 0.0, 1.0) * _DepthFactor;
    vec4 waterColor = mix(_DepthGradientShallow, _DepthGradientDeep, waterDepth);
    vec4 color = alphaBlend(waterColor, waterColor);
    NORMAL = v_normal;
    ALBEDO = color.rgb;
    ALPHA = color.a;
    ROUGHNESS = 0.1;
    CLEARCOAT = 1.0;
    CLEARCOAT_ROUGHNESS = 0.0;
    METALLIC = 0.5;
}
