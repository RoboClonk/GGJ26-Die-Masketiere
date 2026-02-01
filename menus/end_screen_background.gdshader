shader_type canvas_item;

uniform float sway_speed = 0.2;
/*
  0.0 = no movement
  1.0 = exactly one full screen width/height
*/
uniform float screen_scale = 1.0;

void vertex() {
    float t = TIME * sway_speed;

    // 0 → 1 → 0 smooth loop
    float k = (1.0 - cos(t)) * 0.5;

    // Viewport size in pixels
	float num = 10.0;
    vec2 screen_size = vec2(18.0 * num, 10.0 * num);

    // Move towards top-right
    vec2 offset = vec2(
        -screen_size.x * screen_scale * k,
         screen_size.y * screen_scale * k
    );

    VERTEX.xy += offset;
}
