// Complete Ebike Frame Assembly
// Renders all components in their assembled positions

include <geometry.scad>

// Override $fn for assembly preview performance
$fn = fn_assembly;

// Metal transparency for geometry verification (1.0 = opaque, 0.3 = transparent)
alpha_metal = 1;

// Debug colors for socket alignment visualization
// Set to "invisible" to hide, or a color name to show debugging pins
debug_down_tube = "invisible";
debug_top_tube = "invisible";
debug_seat_tube = "invisible";
debug_chainstay = "invisible";
debug_seatstay = "invisible";
debug_bb_junction = "invisible";
debug_head_tube_lug = "invisible";
debug_seat_tube_junction = "invisible";
debug_seat_tube_mid_junction = "invisible";
debug_dropout_junction = "invisible";

// Import component modules
use <components/bb_shell.scad>
use <components/head_tube.scad>
use <components/dropout.scad>
use <components/seat_collar.scad>
use <components/down_tube_gusset.scad>
use <components/tube_sleeve.scad>
use <components/bb_junction.scad>
use <components/head_tube_lug.scad>
use <components/seat_tube_junction.scad>
use <components/seat_tube_mid_junction.scad>
use <components/dropout_junction.scad>
use <components/motor_mount.scad>
use <components/brake_mount.scad>
use <components/cable_guide.scad>
use <components/rack_mount.scad>
use <lib/tube_primitives.scad>

// =============================================================================
// ASSEMBLY
// =============================================================================
module frame_assembly() {

    // --- BB JUNCTION ---
    bb_junction(debug_color = debug_bb_junction, body_color = color_metal, alpha = alpha_metal);

    // --- DOWN TUBE ---
    // Positioned from BB junction to head tube lug
    // TODO: Add through holes for battery/bottle rivnut mounts
    orient_to(bb_down_tube, ht_down_tube)
        sectioned_tube(DOWN_TUBE, down_tube_length, debug_color = debug_down_tube, body_color = color_plastic);

    // --- HEAD TUBE LUG ---
    // Using repositioned lug with origin at downtube socket cap
    // Simply orient along downtube and position at downtube end
    color(color_metal, alpha_metal)
        orient_to(bb_down_tube, ht_down_tube)
            translate([0, 0, down_tube_length])
                head_tube_lug();

    // --- TOP TUBE ---
    // Connects from head tube lug top extension socket to seat tube mid-junction
    orient_to(st_top_tube, ht_top_tube)
        sectioned_tube(TOP_TUBE, top_tube_length, debug_color = debug_top_tube, body_color = color_plastic);

    // --- SEAT TUBE ---
    // Connects from bb_seat_tube to st_top
    // Has through holes for seat tube mid-junction bolts
    orient_to(bb_seat_tube, st_top)
        sectioned_tube(SEAT_TUBE, seat_tube_length,
             through_holes=[st_mid_junction_bolt1_distance,
                            st_mid_junction_bolt2_distance],
             debug_color = debug_seat_tube, body_color = color_plastic);

    // --- SEAT TUBE JUNCTION (TOP) ---
    // Position so junction top is near st_top
    // stj_height = 60, so place junction at (actual_length - 60) along tube
    orient_to(bb_seat_tube, st_top)
        translate([0, 0, norm(st_top - bb_seat_tube)])
            seat_tube_junction(debug_color = debug_seat_tube_junction, body_color = color_metal, alpha = alpha_metal);

    // --- SEAT TUBE MID-JUNCTION ---
    // Position at end of top tube, oriented along top tube direction
    orient_to(ht_top_tube, st_top_tube)
        translate([0, 0, top_tube_length])
            seat_tube_mid_junction(debug_color = debug_seat_tube_mid_junction, body_color = color_metal, alpha = alpha_metal);

    // --- CHAINSTAYS ---
    // Connect from bb area to dropout area
    // Tube starts at socket entrance, not at base point
    for (side = [-1, 1])
        orient_to([0, side * cs_spread, bb_chainstay_z],
                  dropout + [0, side * cs_spread, dropout_chainstay_z])
            translate([0, 0, tube_extension_depth(CHAINSTAY) - tube_socket_depth(CHAINSTAY) + bb_shell_od/2])
                sectioned_tube(CHAINSTAY, chainstay_length, debug_color = debug_chainstay, body_color = color_plastic);

    // --- SEAT STAYS ---
    // Connect from seat tube junction collar to dropout
    // Positioned along seat tube direction to align with angled seat tube
    for (side = [-1, 1])
        orient_to(st_seat_stay_base + [0, side * ss_spread, 0],
                  dropout + [0, side * ss_spread, dropout_seat_stay_z])
            sectioned_tube(SEATSTAY, seat_stay_length, debug_color = debug_seatstay, body_color = color_plastic);

    // --- DROPOUT JUNCTIONS ---
    for (side = [-1, 1]) {
        translate(dropout + [0, side * cs_spread, 0])
            dropout_junction(side, debug_color = debug_dropout_junction, body_color = color_metal, alpha = alpha_metal);
    }

//    // --- TT STEP DEBUG CYLINDERS ---
//    debug_cylinder_diameter = 5;
//    debug_cylinder_length = 200;
//
//    // Red: Step 1 - ht_down_tube (starting point)
//    color("red", 0.8)
//        translate(tt_step1)
//            rotate([90, 0, 0])
//                cylinder(h = debug_cylinder_length, d = debug_cylinder_diameter, center = true);
//
//    // Green: Step 2 - after moving along downtube direction
//    color("green", 0.8)
//        translate(tt_step2)
//            rotate([90, 0, 0])
//                cylinder(h = debug_cylinder_length, d = debug_cylinder_diameter, center = true);
//
//    // Blue: Step 3 - after moving up head tube direction
//    color("blue", 0.8)
//        translate(tt_step3)
//            rotate([90, 0, 0])
//                cylinder(h = debug_cylinder_length, d = debug_cylinder_diameter, center = true);
//
//    // Yellow: Step 4 - final socket position (after moving along top tube direction)
//    color("yellow", 0.8)
//        translate(tt_step4)
//            rotate([90, 0, 0])
//                cylinder(h = debug_cylinder_length, d = debug_cylinder_diameter, center = true);

    // NOTE: Additional components (dropouts, motor mount, brake mount,
    // cable guides, rack mounts) removed for geometry verification.
    // Re-add once core frame geometry is confirmed correct.
}

frame_assembly();
