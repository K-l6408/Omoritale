shader_type canvas_item;

void fragment() {
	vec2 uv = UV;
	uv.x += sin(TIME) / 30.;
	uv.y += cos(TIME) / 30.;
	COLOR = texture(TEXTURE, uv);
}
