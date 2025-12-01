// Head Tube Lug
// CNC milled aluminum for NestWorks C500
// Connects head tube to down tube
// Wraps around lower portion of head tube

include <../geometry.scad>
include <../lib/sleeve_primitives.scad>
include <../lib/collar.scad>
include <../lib/tube_sizes.scad>

module head_tube_lug_aligned(body_color = "silver", alpha = 1.0, debug_color = "invisible") {
    // Stepped bore dimensions
    pinch_slot_depth = lug_height - lug_seat_height;  // 40mm clamping section

    // Define collars for down tube and top tube
    collars = [
        // Down tube collar
        Collar(DOWN_TUBE, [-dt_angle, 0, 0], down_tube_extension_translation, cap = true),
        // Top tube collar
        Collar(TOP_TUBE, [-tt_angle, 0, 0], top_extension_translation + down_tube_extension_translation, cap = true)
    ];

    // Pinch bolt count (single bolt)
    bolt_count = 2;

    difference() {
        // Use pinched_sleeve with stepped bore and collars
        pinched_sleeve(HEAD_TUBE_UPPER, HEAD_TUBE, lug_height, pinch_slot_depth, collars, bolt_count, body_color = body_color, alpha = alpha, debug_color = debug_color);
        
        translate([0, 0, lug_height * 3/2])
            cylinder(h = lug_height, center = true);
    }
}

// Wrapper to reposition origin at downtube socket cap center
module head_tube_lug(body_color = "silver", alpha = 1.0, debug_color = "invisible") {
    socket_depth = tube_socket_depth(DOWN_TUBE);
    extension_depth = tube_extension_depth(DOWN_TUBE);

    translate([0, 0, extension_depth - socket_depth])
        rotate([180+dt_angle, 0, 90])
            translate([0, 0, -down_tube_extension_translation])
                head_tube_lug_aligned(body_color = body_color, alpha = alpha, debug_color = debug_color);
}

// Render for preview
head_tube_lug();
