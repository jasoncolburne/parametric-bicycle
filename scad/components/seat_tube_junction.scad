// Seat Tube Top Junction
// CNC milled aluminum for NestWorks C500
// Connects seat tube top to seat stays
// Also serves as seat collar mount

include <../geometry.scad>
include <../lib/collar.scad>
include <../lib/sleeve_primitives.scad>

module seat_tube_junction_core(debug_color = "invisible", body_color = "silver", alpha = 1.0) {
    // Seat stay direction vectors (from geometry.scad)
    // Use the same direction calculation as in geometry.scad for consistency
    ss_socket_depth = tube_socket_depth(SEATSTAY);
    ss_extension_depth = tube_extension_depth(SEATSTAY);

    // Calculate seat stay directions - must match tube direction exactly
    // Tubes travel from st_seat_stay_base to dropout
    ss_left_start = st_seat_stay_base + [-ss_spread, 0, 0];
    ss_right_start = st_seat_stay_base + [ss_spread, 0, 0];
    ss_left_end = dropout + [-ss_spread, 0, dropout_seat_stay_z];
    ss_right_end = dropout + [ss_spread, 0, dropout_seat_stay_z];

    // Direction vectors must match tube direction
    ss_left_dir = ss_left_end - ss_left_start;
    ss_right_dir = ss_right_end - ss_right_start;

    // Collar rotations to align with seat stay tubes
    // Adjust for junction's coordinate system (rotated 90° around Z)
    ss_left_rot = vector_to_euler(ss_left_dir) + [0, 0, -90] - vector_to_euler(st_unit); 
    ss_right_rot = vector_to_euler(ss_right_dir) + [0, 0, -90] - vector_to_euler(st_unit);

    // Create seat stay collars
    ss_left_collar = Collar(SEATSTAY, ss_left_rot, st_seat_stay_collar_height, [-ss_spread, 0, 0], cap = true);
    ss_right_collar = Collar(SEATSTAY, ss_right_rot, st_seat_stay_collar_height, [ss_spread, 0, 0], cap = true);

    pinched_sleeve(SEAT_POST, SEAT_TUBE, stj_height, 25, [ss_left_collar, ss_right_collar], 1, debug_color, body_color, alpha);
}

// Render for preview
module seat_tube_junction(debug_color = "invisible", body_color = "silver", alpha = 1.0) {
    translate([0, 0, -st_seat_stay_collar_height])
        rotate([0, 0, 90])
            seat_tube_junction_core(debug_color, body_color, alpha);
}

seat_tube_junction();