shader_type canvas_item;

uniform float speed = 1.0;

void fragment() {
	vec2 uv = UV / 2.;
	uv.x += TIME * speed * 1.5;
	uv.x += floor(mod(uv.y, 2)) / 2.;
	COLOR = texture(TEXTURE, uv);
}
