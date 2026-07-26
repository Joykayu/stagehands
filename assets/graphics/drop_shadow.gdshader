shader_type canvas_item;

uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.4);
uniform float blur_size : hint_range(0.0, 10.0) = 3.0;

void fragment() {
	vec2 ps = TEXTURE_PIXEL_SIZE;
	float br = blur_size * ps.x;

	float alpha = texture(TEXTURE, UV).a * 0.25;
	alpha += texture(TEXTURE, UV + vec2( br, 0.0)).a * 0.1875;
	alpha += texture(TEXTURE, UV - vec2( br, 0.0)).a * 0.1875;
	alpha += texture(TEXTURE, UV + vec2(0.0,  br)).a * 0.1875;
	alpha += texture(TEXTURE, UV - vec2(0.0,  br)).a * 0.1875;

	COLOR = vec4(shadow_color.rgb, shadow_color.a * alpha);
}
