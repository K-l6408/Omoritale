shader_type canvas_item;

void fragment() {
	vec2 uv = UV;
	uv.x += uv.y * sin(TIME) / 10.;
	COLOR = texture(TEXTURE, uv);
}
