shader_type canvas_item;

void fragment() {
	vec2 uv = UV;
	uv.x += TIME * 3.;
	uv.x += floor(mod(uv.y, 2)) / 2.;
	COLOR = texture(TEXTURE, uv);
}
