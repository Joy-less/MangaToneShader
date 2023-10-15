// Manga Tone Shader for Godot (CC0)
// Made by Joy-less: https://joy-less.itch.io
// Original by Exuin: https://godotshaders.com/shader/screentone-black-spaced-pixels

shader_type canvas_item;

uniform bool enabled = true;
uniform bool duo_grayscale = false; // Two-tone grayscale (manga)
uniform bool grayscale = false; // Depth grayscale (old photos)
uniform float light = 1; // Light pixel brightness
uniform float dark = 0.5; // Dark pixel brightness
uniform float dot_spread = 17.0; // How far apart the dots are
uniform float dot_size = 1; // The size of each dot

bool is_light_pixel(float average, ivec2 pixel_pos) {
 	int max_i = int(average * dot_spread);
	
	return (((pixel_pos.x) % 4 == 0 && (pixel_pos.y + 3) % 4 == 0)
		|| (max_i > 1 && (pixel_pos.x + 2) % 4 == 0 && (pixel_pos.y + 1) % 4 == 0)
		|| (max_i > 2 && (pixel_pos.x + 2) % 4 == 0 && (pixel_pos.y + 3) % 4 == 0)
		|| (max_i > 3 && (pixel_pos.x) % 4 == 0 && (pixel_pos.y + 1) % 4 == 0)
		|| (max_i > 4 && (pixel_pos.x + 1) % 4 == 0 && (pixel_pos.y + 2) % 4 == 0)
		|| (max_i > 5 && (pixel_pos.x + 3) % 4 == 0 && (pixel_pos.y) % 4 == 0)
		|| (max_i > 6 && (pixel_pos.x + 3) % 4 == 0 && (pixel_pos.y + 2) % 4 == 0)
		|| (max_i > 7 && (pixel_pos.x + 1) % 4 == 0 && (pixel_pos.y) % 4 == 0)
		|| (max_i > 8 && (pixel_pos.x + 1) % 4 == 0 && (pixel_pos.y + 3) % 4 == 0)
		|| (max_i > 9 && (pixel_pos.x + 3) % 4 == 0 && (pixel_pos.y + 1) % 4 == 0)
		|| (max_i > 10 && (pixel_pos.x + 3) % 4 == 0 && (pixel_pos.y + 3) % 4 == 0)
		|| (max_i > 11 && (pixel_pos.x + 1) % 4 == 0 && (pixel_pos.y + 1) % 4 == 0)
		|| (max_i > 12 && (pixel_pos.x) % 4 == 0 && (pixel_pos.y + 2) % 4 == 0)
		|| (max_i > 13 && (pixel_pos.x + 2) % 4 == 0 && (pixel_pos.y) % 4 == 0)
		|| (max_i > 14 && (pixel_pos.x + 2) % 4 == 0 && (pixel_pos.y + 2) % 4 == 0)
		|| (max_i > 15)
	);
}

void fragment() {
	if (enabled) {
		vec4 current_pixel = texture(TEXTURE, UV);
		ivec2 pixel_pos = ivec2(UV / TEXTURE_PIXEL_SIZE / dot_size / (SCREEN_PIXEL_SIZE * vec2(1920, 1080)));
		float average = (current_pixel.r + current_pixel.g + current_pixel.b) / 3.0;
		
		if (duo_grayscale)
			COLOR = vec4(1);
		
		COLOR *= vec4((
			is_light_pixel(average, pixel_pos)
			? (duo_grayscale ? vec3(light - 0.5) : vec3(light))
			: (duo_grayscale ? vec3(dark - 0.5) : vec3(dark))
		), current_pixel.a);
		
		if (grayscale)
			COLOR.r = COLOR.g = COLOR.b = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
	}
}