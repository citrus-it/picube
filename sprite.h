
typedef struct sprite {
	byte buffer[6][6][6];
	byte description[6][6][6];

	// Sprite dimensions
	int myX, myY, myZ;
	int intensity;

	int place[3];	// lower corner position of sprite
	int motion[3];	// direction to move when asked.
} *sprite;

sprite sprite_create(int, int, int);
void sprite_delete(sprite);
void sprite_description(sprite, byte d[6][6][6]);
void sprite_copyback(sprite);
void sprite_colorIt(sprite, int);
void sprite_outline(sprite, int);
void sprite_place(sprite, int, int, int);
void sprite_placeX(sprite, int, int);
void sprite_motion(sprite, int, int, int);
void sprite_setIt(sprite);
void sprite_clearIt(sprite);
void sprite_moveIt(sprite);
void sprite_bounceIt(sprite);
void sprite_sphere(sprite, int);
void sprite_rollX(sprite, int);
void sprite_rollY(sprite, int);
void sprite_rollZ(sprite, int);
void sprite_rotateX(sprite, int);
void sprite_rotateY(sprite, int);
void sprite_rotateZ(sprite, int);
void sprite_ChgIntensity(sprite, int);


