// Credits - Shadertoy.com, user Knarkowicz
shader_type canvas_item;

uniform float radius = 64.0;          // fully lit radius in pixels (original: 4 tiles * 16)
uniform float falloff = 0.05;         // how quickly light fades past the radius (original: 0.05)
uniform float min_brightness : hint_range(0.0, 1.0) = 0.2; // darkest the edges get (original: 0.2)
uniform float pixel_size = 1.0;       // set to e.g. 4.0 for chunky, pixel-art-style steps
uniform vec2 center_offset = vec2(0.0, 0.0); // nudge the light if the sprite isn't exactly centered
uniform vec4 darkness_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
	vec2 viewport_size = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 center = viewport_size * 0.5 + center_offset;

	// snap to a pixel grid so the edge looks stepped like the original
	vec2 p = floor(FRAGCOORD.xy / pixel_size) * pixel_size + pixel_size * 0.5;

	float dist = length(p - center);

	// same curve as the original: smoothstep of the clamped distance falloff
	float t = clamp((radius - dist) * falloff, 0.0, 1.0);
	float light = smoothstep(0.0, 1.0, t) * (1.0 - min_brightness) + min_brightness;

	COLOR = vec4(darkness_color.rgb, (1.0 - light) * darkness_color.a);
}