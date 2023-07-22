shader_type canvas_item;

void fragment() {
	vec2 uv = UV;
	uv.x += sin(TIME) / 25.;
	uv.y += cos(TIME) / 50.;
	COLOR = texture(TEXTURE, uv);
}
