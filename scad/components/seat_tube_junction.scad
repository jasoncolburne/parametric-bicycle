// Seat Tube Top Junction
// CNC milled aluminum for NestWorks C500
// Connects seat tube top to seat stays
// Also serves as seat collar mount

include <../geometry.scad>
include <../lib/collar.scad>
include <../lib/sleeve_primitives.scad>

module seat_tube_junction_core(debug_color = "invisible", body_color = "silver") {
    // Seat stay world positions
    ss_left_start = st_top + [-ss_spread, 0, st_seat_stay_z];
    ss_right_start = st_top + [ss_spread, 0, st_seat_stay_z];
    ss_left_end = dropout + [-ss_spread, 0, dropout_seat_stay_z];
    ss_right_end = dropout + [ss_spread, 0, dropout_seat_stay_z];

    // Direction vectors
    ss_left_dir = ss_left_end - ss_left_start;
    ss_right_dir = ss_right_end - ss_right_start;

    // Collar rotations
    ss_left_rot = vector_to_euler(ss_left_dir) + [0, 0, -90];
    ss_right_rot = vector_to_euler(ss_right_dir) + [0, 0, -90];

    // Create seat stay collars (using height from geometry.scad, no translation needed)
    ss_left_collar = Collar(SEATSTAY, ss_left_rot, st_seat_stay_collar_height, [-ss_spread, 0, 0], cap = true);
    ss_right_collar = Collar(SEATSTAY, ss_right_rot, st_seat_stay_collar_height, [ss_spread, 0, 0], cap = true);

    pinched_sleeve(SEAT_POST, SEAT_TUBE, stj_height, 25, [ss_left_collar, ss_right_collar], 1, debug_color, body_color);
}

// Render for preview
module seat_tube_junction(debug_color = "invisible", body_color = "silver") {
    translate([0, 0, -stj_origin_offset])
        rotate([0, 0, 90])
            seat_tube_junction_core(debug_color, body_color);
}

seat_tube_junction();