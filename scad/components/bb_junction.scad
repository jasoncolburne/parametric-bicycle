// BB Junction
// CNC milled aluminum for NestWorks C500
// Central frame junction at bottom bracket
// Receives: down tube, seat tube, left/right chainstays
// Integrates with BB shell

include <../geometry.scad>
include <../lib/collar.scad>
include <../lib/sleeve_primitives.scad>

// Junction dimensions
bb_wall = 6;                 // Wall thickness around BB shell
bb_bore_length = 130;        // Total pedal bore length (e-bike mid-drive clearance)

module bb_junction(debug_color = "invisible", body_color = "silver", alpha = 1.0) {
    // Use collar configuration from geometry.scad
    dt_collar = Collar(DOWN_TUBE, bb_dt_collar_internal_rotation, bb_dt_collar_height);
    st_collar = Collar(SEAT_TUBE, bb_st_collar_internal_rotation, bb_st_collar_height);

    // Chainstay collar configuration
    // Chainstay direction: from BB toward dropout
    cs_start = [0, 0, bb_chainstay_z];  // At BB (centerline in Y)
    cs_end = [dropout_x, 0, dropout_chainstay_z];  // At dropout (centerline in Y)
    cs_dir = cs_end - cs_start;  // Direction toward dropout
    cs_unit = cs_dir / norm(cs_dir);

    cs_rot = vector_to_euler(cs_dir);

    // Socket depths
    cs_socket_depth = tube_socket_depth(CHAINSTAY);
    cs_extension_depth = tube_extension_depth(CHAINSTAY);
    cs_offset_dist = cs_extension_depth - cs_socket_depth;
    cs_offset = cs_offset_dist * cs_unit;

    // Translation to position socket entrance at [0, ±cs_spread, bb_chainstay_z]
    // Collar extends forward from its base, so translate forward by offset along tube direction
    cs_tube_end_left = [0, cs_spread, bb_chainstay_z];
    cs_tube_end_right = [0, -cs_spread, bb_chainstay_z];
    cs_left_translation = cs_tube_end_left + cs_offset;
    cs_right_translation = cs_tube_end_right + cs_offset;

    // Height = 0 since Y positioning is done via translation
    cs_left_collar = Collar(CHAINSTAY, cs_rot, 0, cs_left_translation, cap = true);
    cs_right_collar = Collar(CHAINSTAY, cs_rot, 0, cs_right_translation, cap = true);

    difference() {
        union() {
            // Central cylinder for BB shell
            color(body_color, alpha)
                rotate([90, 0, 0])
                    cylinder(h = bb_bore_length, d = bb_shell_od + 2*bb_wall, center = true);

            // Down tube collar
            rotate(bb_dt_collar_rotation)
                sleeve_collar(dt_collar, geometry = "positive", debug_color = debug_color, body_color = body_color, alpha = alpha);

            // Seat tube collar
            rotate(bb_st_collar_rotation)
                sleeve_collar(st_collar, geometry = "positive", debug_color = debug_color, body_color = body_color, alpha = alpha);

            // Chainstay collars
            sleeve_collar(cs_left_collar, geometry = "positive", debug_color = debug_color, body_color = body_color, alpha = alpha);
            sleeve_collar(cs_right_collar, geometry = "positive", debug_color = debug_color, body_color = body_color, alpha = alpha);
        }

        // Down tube collar negative
        rotate(bb_dt_collar_rotation)
            sleeve_collar(dt_collar, geometry = "negative");

        // Seat tube collar negative
        rotate(bb_st_collar_rotation)
            sleeve_collar(st_collar, geometry = "negative");

        // Chainstay collar negatives
        sleeve_collar(cs_left_collar, geometry = "negative");
        sleeve_collar(cs_right_collar, geometry = "negative");

        // BB shell bore (through center, lateral)
        rotate([90, 0, 0])
            cylinder(h = bb_bore_length * 2, d = bb_shell_od + 0.5, center = true);
    }
}

// Render for preview
bb_junction();
