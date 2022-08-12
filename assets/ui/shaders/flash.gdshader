shader_type canvas_item;
// If you want to make the flash effect less opaque, you can toggle the flash_modifer: hint_range
uniform vec4 flash_color: hint_color = vec4(1.0);
uniform float flash_modifier: hint_range(0.0,1) = 1;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, flash_color.rgb, flash_modifier);
	COLOR = color;
}