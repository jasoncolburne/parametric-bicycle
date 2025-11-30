// Dropout Junction
// CNC milled aluminum for NestWorks C500
// Connects chainstay and seat stay to dropout
// One required per side (left and right)

include <../geometry.scad>
include <../lib/collar.scad>
include <../lib/sleeve_primitives.scad>

module dropout_junction_core(side = 1, debug_color = "invisible", body_color = "silver", alpha = 1.0) {
    // Calculate tube directions in junction's local coordinate system
    // Junction is positioned at: dropout + [0, side * cs_spread, 0]

    // Chainstay direction: from BB to dropout
    // But collar needs to point TOWARD the tube source, so reverse it
    cs_start_world = [0, side * cs_spread, bb_chainstay_z];
    cs_end_world = dropout + [0, side * cs_spread, dropout_chainstay_z];
    cs_dir = cs_start_world - cs_end_world;  // Reversed: point toward BB

    // Seat stay direction: from seat tube junction to dropout
    // But collar needs to point TOWARD the tube source, so reverse it
    ss_start_world = st_seat_stay_base + [0, side * ss_spread, 0];
    ss_end_world = dropout + [0, side * ss_spread, dropout_seat_stay_z];
    ss_dir = ss_start_world - ss_end_world;  // Reversed: point toward seat tube junction

    // Calculate rotations for collars
    cs_rot = vector_to_euler(cs_dir);
    ss_rot = vector_to_euler(ss_dir);

    // Socket depths
    cs_socket_depth = tube_socket_depth(CHAINSTAY);
    ss_socket_depth = tube_socket_depth(SEATSTAY);
    cs_extension_depth = tube_extension_depth(CHAINSTAY);
    ss_extension_depth = tube_extension_depth(SEATSTAY);

    // Local positions of collar socket entrances (relative to junction origin at dropout + [0, side * cs_spread, 0])
    // The tube socket end should INSERT into the collar socket
    // Collar extends (extension_depth - socket_depth) forward from its origin
    // So we need to move collar origin back by that amount along the tube direction
    cs_dir_unit = cs_dir / norm(cs_dir);
    ss_dir_unit = ss_dir / norm(ss_dir);

    cs_tube_end = [0, 0, dropout_chainstay_z];
    ss_tube_end = [0, side * (ss_spread - cs_spread), dropout_seat_stay_z];

    cs_local = cs_tube_end - (cs_extension_depth - cs_socket_depth) * cs_dir_unit;
    ss_local = ss_tube_end - (ss_extension_depth - ss_socket_depth) * ss_dir_unit;

    // Create collars with height = 0 (all positioning done via translation)
    // axis_rotation depends on side to rotate socket bore outward for weather resistance
    cs_collar = Collar(CHAINSTAY, cs_rot, 0, cs_local, cap = true, axis_rotation = -side * 90);
    ss_collar = Collar(SEATSTAY, ss_rot, 0, ss_local, cap = true, axis_rotation = -side * 90);

    // Main junction body using sleeve primitive
    difference() {
        hull() {
            union() {
                // Axle boss
                color(body_color, alpha)
                    sphere(r = dropout_axle_diameter/2 + 10);
            }

            // Chainstay collar positive
            sleeve_collar(cs_collar, geometry = "positive", debug_color = debug_color, body_color = body_color, alpha = alpha);

            // Seat stay collar positive
            sleeve_collar(ss_collar, geometry = "positive", debug_color = debug_color, body_color = body_color, alpha = alpha);
        }

        // Chainstay collar negative
        sleeve_collar(cs_collar, geometry = "negative");

        // Seat stay collar negative
        sleeve_collar(ss_collar, geometry = "negative");

        // Axle clearance
        rotate([90, 0, 0])
            cylinder(h = 100, d = dropout_axle_diameter + 2, center = true);
    }
}

module dropout_junction(side = 1, debug_color = "invisible", body_color = "silver", alpha = 1.0) {
    dropout_junction_core(side, debug_color, body_color, alpha);
}

// Render for preview or build (set via -D render_side=N)
render_side = 1;  // Default for preview (right side)

dropout_junction(render_side);
