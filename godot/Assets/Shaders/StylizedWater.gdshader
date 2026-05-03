shader_type spatial;

uniform sampler2D base_texture : source_color;
uniform sampler2D noise_img;
uniform sampler2D foam_noise_img;
uniform float height_scale = 0.5;
uniform float uv_scale = 10.0;
uniform float foam_height = 0.8;

varying float height;

const vec3 min_color = vec3(0, 0.5, 1);
const vec3 max_color = vec3(1, 1, 1);

void vertex() {
	float noise_value = texture(noise_img, VERTEX.xz * 0.01 + TIME * 0.06).r;
	noise_value = clamp(noise_value, 0.0, 1.0);
	
	VERTEX.y = noise_value * height_scale;
	height = noise_value;
}

void fragment() {
	vec2 tiled_uv = UV * uv_scale;
	
	vec3 tex_color = texture(base_texture, tiled_uv).rgb;
	vec3 tint = mix(min_color, max_color, height);
	float noise_value = texture(foam_noise_img, VERTEX.xy + TIME * 0.5).r;
	if (noise_value > 0.2 && height >= foam_height ) {
		ALBEDO = mix(tex_color, max_color, 1.0);
		ALPHA = 1.0;
	}  else {
		ALBEDO = mix(tex_color, tint, noise_value/2.0);
		ALPHA = clamp(height, 0.8, 1.0);
	};
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
