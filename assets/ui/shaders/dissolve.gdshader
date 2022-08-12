shader_type canvas_item;
uniform sampler2D tex_frg_4;
uniform float Thickness;


void vertex() {
// Output:0

}

void fragment() {
// Input:3
	vec3 n_out3p0 = vec3(UV, 0.0);

// Texture:2
	vec3 n_out2p0;
	float n_out2p1;
	{
		vec4 _tex_read = texture(TEXTURE, n_out3p0.xy);
		n_out2p0 = _tex_read.rgb;
		n_out2p1 = _tex_read.a;
	}

// Input:5
	vec3 n_out5p0 = vec3(UV, 0.0);

// Texture:4
	vec4 tex_frg_4_read = texture(tex_frg_4, n_out5p0.xy);
	vec3 n_out4p0 = tex_frg_4_read.rgb;
	float n_out4p1 = tex_frg_4_read.a;

// Input:9
	float n_out9p0 = TIME;

// ScalarFunc:10
	float n_out10p0 = sin(n_out9p0);

// ScalarFunc:11
	float n_out11p0 = abs(n_out10p0);

// ScalarOp:7
	float n_out7p0 = step(dot(n_out4p0, vec3(0.333333, 0.333333, 0.333333)), n_out11p0);

// ScalarUniform:18
	float n_out18p0 = Thickness;

// ScalarOp:13
	float n_out13p0 = n_out11p0 - n_out18p0;

// ScalarOp:12
	float n_out12p0 = step(dot(n_out4p0, vec3(0.333333, 0.333333, 0.333333)), n_out13p0);

// ScalarOp:14
	float n_out14p0 = n_out7p0 - n_out12p0;

// Color:16
	vec3 n_out16p0 = vec3(0.728487, 0.173351, 0.173351);
	float n_out16p1 = 1.000000;

// VectorOp:15
	vec3 n_out15p0 = vec3(n_out14p0) * n_out16p0;

// ColorOp:17
	vec3 n_out17p0 = vec3(1.0) - (vec3(1.0) - n_out2p0) * (vec3(1.0) - n_out15p0);

// ScalarOp:6
	float n_out6p0 = n_out2p1 * n_out7p0;

// Output:0
	COLOR.rgb = n_out17p0;
	COLOR.a = n_out6p0;

}

void light() {
// Output:0

}
