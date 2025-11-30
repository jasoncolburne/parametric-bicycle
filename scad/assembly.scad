// Complete Ebike Frame Assembly
// Renders all components in their assembled positions

include <geometry.scad>

// Override $fn for assembly preview performance
$fn = fn_assembly;

// Metal transparency for geometry verification (1.0 = opaque, 0.3 = transparent)
alpha_metal = 0.25;

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
    color(color_metal, alpha_metal)
        bb_junction();

    // --- DOWN TUBE ---
    // Positioned from BB junction to head tube lug
    // TODO: Add through holes for battery/bottle rivnut mounts
    color(color_plastic)
        orient_to(bb_down_tube, ht_down_tube)
            sectioned_tube(DOWN_TUBE, down_tube_length);

    // --- HEAD TUBE LUG ---
    // Using repositioned lug with origin at downtube socket cap
    // Simply orient along downtube and position at downtube end
    color(color_metal, alpha_metal)
        orient_to(bb_down_tube, ht_down_tube)
            translate([0, 0, down_tube_length])
                head_tube_lug();

    // --- TOP TUBE ---
    // Connects from head tube lug top extension socket to seat tube mid-junction
    color(color_plastic)
        orient_to(st_top_tube, ht_top_tube)
            sectioned_tube(TOP_TUBE, top_tube_length);

    // --- SEAT TUBE ---
    // Connects from bb_seat_tube to st_top
    // Has through holes for seat tube mid-junction bolts
    color(color_plastic)
        orient_to(bb_seat_tube, st_top)
            sectioned_tube(SEAT_TUBE, seat_tube_length,
                 through_holes=[st_mid_junction_bolt1_distance,
                                st_mid_junction_bolt2_distance]);

    // --- SEAT TUBE JUNCTION (TOP) ---
    // Position so junction top is near st_top
    // stj_height = 60, so place junction at (actual_length - 60) along tube
    color(color_metal, alpha_metal)
        orient_to(bb_seat_tube, st_top)
            translate([0, 0, norm(st_top - bb_seat_tube)])
                seat_tube_junction();

    // --- SEAT TUBE MID-JUNCTION ---
    // Position at end of top tube, oriented along top tube direction
    color(color_metal, alpha_metal)
        orient_to(ht_top_tube, st_top_tube)
            translate([0, 0, top_tube_length])
                seat_tube_mid_junction();

    // --- CHAINSTAYS ---
    // Connect from bb area to dropout area
    color(color_plastic)
        for (side = [-1, 1])
            orient_to([0, side * cs_spread, bb_chainstay_z],
                      dropout + [0, side * cs_spread, dropout_chainstay_z])
                sectioned_tube(CHAINSTAY, chainstay_length);

    // --- SEAT STAYS ---
    // Connect from st_top area to dropout area
    // Keep at ss_spread for structural rigidity (no convergence with chainstay)
    // Tube starts at socket entrance (Z=5mm), inserts 25mm into socket
    // Tube bolt at 12.5mm from start aligns with junction bolt at Z=17.5 (socket center)
    color(color_plastic)
        for (side = [-1, 1])
            orient_to(st_top + [0, side * ss_spread, st_seat_stay_z],
                      dropout + [0, side * ss_spread, dropout_seat_stay_z])
                sectioned_tube(SEATSTAY, seat_stay_length);

    // --- DROPOUT JUNCTIONS ---
    color(color_metal, alpha_metal)
        for (side = [-1, 1]) {
            translate(dropout + [0, side * cs_spread, 0])
                dropout_junction(side);
        }

    // --- BB SHELL ---
    // Centered at origin, oriented laterally (along Y axis)
    color(color_metal, alpha_metal)
        rotate([90, 0, 0])
            translate([0, 0, -bb_shell_width/2])
                bb_shell();

    // --- DEBUG CYLINDERS ---
    debug_cylinder_diameter = 5;
    debug_cylinder_length = 200;

    // Red: bb_down_tube socket position (pointing along Y axis)
    color("red", 0.8)
        translate(bb_down_tube)
            rotate([90, 0, 0])
                cylinder(h = debug_cylinder_length, d = debug_cylinder_diameter, center = true);

    // Green: bb_seat_tube socket position (pointing along Y axis)
    color("green", 0.8)
        translate(bb_seat_tube)
            rotate([90, 0, 0])
                cylinder(h = debug_cylinder_length, d = debug_cylinder_diameter, center = true);


    // Red: Step 1 - ht_down_tube (starting point)
    color("red", 0.8)
        translate(tt_step1)
            rotate([90, 0, 0])
                cylinder(h = debug_cylinder_length, d = debug_cylinder_diameter, center = true);

    // Green: Step 2 - after moving along downtube direction
    color("green", 0.8)
        translate(tt_step2)
            rotate([90, 0, 0])
                cylinder(h = debug_cylinder_length, d = debug_cylinder_diameter, center = true);

    // Blue: Step 3 - after moving up head tube direction
    color("blue", 0.8)
        translate(tt_step3)
            rotate([90, 0, 0])
                cylinder(h = debug_cylinder_length, d = debug_cylinder_diameter, center = true);

    // Yellow: Step 4 - final socket position (after moving along top tube direction)
    color("yellow", 0.8)
        translate(tt_step4)
            rotate([90, 0, 0])
                cylinder(h = debug_cylinder_length, d = debug_cylinder_diameter, center = true);

    // Magenta: st_top_tube (seat tube mid-junction position)
    color("magenta", 0.8)
        translate(st_top_tube)
            rotate([90, 0, 0])
                cylinder(h = debug_cylinder_length, d = debug_cylinder_diameter, center = true);

    // NOTE: Additional components (dropouts, motor mount, brake mount,
    // cable guides, rack mounts) removed for geometry verification.
    // Re-add once core frame geometry is confirmed correct.
}

frame_assembly();
