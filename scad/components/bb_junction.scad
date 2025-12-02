// BB Junction
// CNC milled aluminum for NestWorks C500
// Central frame junction at bottom bracket
// Receives: down tube, seat tube, left/right chainstays
// Integrates with BB shell

include <../geometry.scad>
include <../lib/collar.scad>
include <../lib/sleeve_primitives.scad>

module bb_junction(debug_color = "invisible", body_color = "silver", alpha = 1.0) {
    // Use collar configuration from geometry.scad
    dt_collar = Collar(DOWN_TUBE, bb_dt_collar_internal_rotation, bb_dt_collar_height);
    st_collar = Collar(SEAT_TUBE, bb_st_collar_internal_rotation, bb_st_collar_height);

    // Chainstay collar configuration
    // Left and right chainstays have different directions due to Y spread
    cs_left_start = [0, cs_spread, bb_chainstay_z];
    cs_left_end = dropout + [0, cs_spread, dropout_chainstay_z];
    cs_left_dir = cs_left_end - cs_left_start;
    cs_left_unit = cs_left_dir / norm(cs_left_dir);

    cs_right_start = [0, -cs_spread, bb_chainstay_z];
    cs_right_end = dropout + [0, -cs_spread, dropout_chainstay_z];
    cs_right_dir = cs_right_end - cs_right_start;
    cs_right_unit = cs_right_dir / norm(cs_right_dir);

    cs_left_rot = vector_to_euler(cs_left_dir);
    cs_right_rot = vector_to_euler(cs_right_dir);

    // Socket depths
    cs_offset_dist = bb_shell_od / 2;
    cs_left_offset = cs_offset_dist * cs_left_unit;
    cs_right_offset = cs_offset_dist * cs_right_unit;

    // Translation to position socket entrance at tube start
    // Collar extends forward from its base, so translate forward by offset along tube direction
    cs_left_translation = cs_left_start + cs_left_offset;
    cs_right_translation = cs_right_start + cs_right_offset;

    // Height = 0 since all positioning is done via translation
    // axis_rotation rotates socket bore outward for weather resistance
    cs_left_collar = Collar(CHAINSTAY, cs_left_rot, 0, cs_left_translation, cap = true, axis_rotation = -90);
    cs_right_collar = Collar(CHAINSTAY, cs_right_rot, 0, cs_right_translation, cap = true, axis_rotation = 90);

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
