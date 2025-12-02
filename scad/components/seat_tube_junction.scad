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
    ss_left_start = st_seat_stay_base + [0, -ss_spread, 0];
    ss_right_start = st_seat_stay_base + [0, ss_spread, 0];
    ss_left_end = dropout + [0, -ss_spread, dropout_seat_stay_z];
    ss_right_end = dropout + [0, ss_spread, dropout_seat_stay_z];

    // Direction vectors must match tube direction
    ss_left_dir = ss_left_end - ss_left_start;
    ss_right_dir = ss_right_end - ss_right_start;

    // Collar rotations to align with seat stay tubes
    // Adjust for junction's coordinate system (rotated 90° around Z)
    ss_left_rot = vector_to_euler(ss_left_dir) + [0, 0, -90] - vector_to_euler(seat_tube_unit);
    ss_right_rot = vector_to_euler(ss_right_dir) + [0, 0, -90] - vector_to_euler(seat_tube_unit);

    // Create seat stay collars
    ss_left_collar = Collar(SEATSTAY, ss_left_rot, st_seat_stay_collar_height, [-ss_spread, 0, 0], cap = true, axis_rotation = 90);
    ss_right_collar = Collar(SEATSTAY, ss_right_rot, st_seat_stay_collar_height, [ss_spread, 0, 0], cap = true, axis_rotation = -90);

    // Seat tube socket bolt positioning
    seat_tube_bolt_height = st_seat_stay_collar_height / 2;  // Midpoint of collar height (which equals socket depth)

    // Bolt sizes for seat tube
    outer_r = tube_outer_radius(SEAT_TUBE);
    thickness = tube_collar_thickness(SEAT_TUBE);
    bolt_size = tube_bolt_size(SEAT_TUBE);
    tap_r = bolt_tap_radius(bolt_size);
    clearance_r = bolt_clearance_radius(bolt_size);
    counterbore_r = bolt_counterbore_radius(bolt_size);
    counterbore_d = bolt_counterbore_depth(bolt_size);
    boss_r = bolt_boss_radius(bolt_size);

    ss_outer_r = tube_outer_radius(SEATSTAY);
    ss_thickness = tube_collar_thickness(SEATSTAY);

    difference() {
        union() {
            pinched_sleeve(SEAT_POST, SEAT_TUBE, stj_height, stj_height - st_seat_stay_collar_height, [ss_left_collar, ss_right_collar], 1, debug_color, body_color, alpha, geometry = "positive", use_hull = true) {
                translate([ss_spread, 0, st_seat_stay_collar_height])
                    sphere(r = ss_outer_r + ss_thickness);

                translate([-ss_spread, 0, st_seat_stay_collar_height])
                    sphere(r = ss_outer_r + ss_thickness);
            }

            // Boss for seat tube socket bolt
            color(body_color, alpha)
                translate([outer_r + thickness, 0, seat_tube_bolt_height])
                    sphere(r = boss_r);
        }

        pinched_sleeve(SEAT_POST, SEAT_TUBE, stj_height, stj_height - st_seat_stay_collar_height, [ss_left_collar, ss_right_collar], 1, debug_color, body_color, alpha, geometry = "negative");

        // Seat tube socket bolt holes
        translate([0, 0, seat_tube_bolt_height])
            rotate([0, 90, 0]) {
                // Tap hole from inner side
                translate([0, 0, outer_r - 2])
                    cylinder(r = tap_r, h = 12);

                // Clearance hole from opposite side
                translate([0, 0, -(outer_r + thickness)])
                    cylinder(r = clearance_r, h = (outer_r + thickness) - (outer_r - 2));

                // Counterbore for socket head
                translate([0, 0, -(outer_r + thickness + 50)])
                    cylinder(r = counterbore_r, h = counterbore_d + 50);
            }
    }
}

// Render for preview
module seat_tube_junction(debug_color = "invisible", body_color = "silver", alpha = 1.0) {
    translate([0, 0, -st_seat_stay_collar_height])
        rotate([0, 0, 90])
            seat_tube_junction_core(debug_color, body_color, alpha);
}

seat_tube_junction();