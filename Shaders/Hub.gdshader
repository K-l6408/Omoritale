shader_type canvas_item;

uniform float m=1;

void fragment() {
	vec2 uv = UV;
	uv.x += sin(TIME*m) / 25.;
	uv.y += cos(TIME*m) / 50.;
	COLOR = texture(TEXTURE, uv);
}
