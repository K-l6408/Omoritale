shader_type spatial;

uniform sampler2D Texture;
instance uniform float Distance = 10.;

void fragment() {
	vec2 uv = UV*vec2(3.,2.);
	uv = mod(uv, vec2(1.));
	ALBEDO = texture(Texture, uv - mod(uv, 1./32.) + vec2(1./64.)).rgb;
	if(Distance < 10.) {
		if((uv.x + uv.y) * 2.5 > Distance - 5.) ALPHA = 0.;
		ALBEDO.gb *= (Distance - 5.) / 5.;
	}
	else {
		ALBEDO.rg *= (20. - Distance) / 10.;
	}
}
