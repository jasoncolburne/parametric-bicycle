// Complete Ebike Frame Assembly
// Renders all components in their assembled positions

include <config.scad>

// Override $fn for assembly preview performance
$fn = fn_assembly;

// Metal transparency for geometry verification (1.0 = opaque, 0.3 = transparent)
alpha_metal = 0.25;

// Import component modules
use <components/metal/bb_shell.scad>
use <components/metal/head_tube.scad>
use <components/metal/dropout.scad>
use <components/metal/seat_collar.scad>
use <components/metal/down_tube_gusset.scad>
use <components/metal/tube_sleeve.scad>
use <components/metal/bb_junction.scad>
use <components/metal/head_tube_lug.scad>
use <components/metal/seat_tube_junction.scad>
use <components/metal/seat_tube_mid_junction.scad>
use <components/metal/dropout_junction.scad>
use <components/metal/motor_mount.scad>
use <components/metal/brake_mount.scad>
use <components/metal/cable_guide.scad>
use <components/metal/rack_mount.scad>
use <components/plastic-cf/down_tube.scad>
use <components/plastic-cf/seat_tube.scad>
use <components/plastic-cf/top_tube.scad>
use <components/plastic-cf/chainstay.scad>
use <components/plastic-cf/seat_stay.scad>

// =============================================================================
// ASSEMBLY
// =============================================================================
module frame_assembly() {

    // --- BB JUNCTION ---
    color(color_metal, alpha_metal)
        bb_junction();

    // --- DOWN TUBE ---
    // Positioned from BB junction, extending toward head tube
    // Offset by -socket_depth (40mm) at head tube end to insert into lug
    // and -junction_socket_depth (25mm) at BB end to insert into BB junction
    // Total extension at head end: 40mm into lug socket
    color(color_plastic)
        orient_to(bb_down_tube, ht_down_tube)
            translate([0, 0, -junction_socket_depth])
                for (i = [0:down_tube_sections-1])
                    translate([0, 0, i * down_tube_section_length])
                        down_tube_section(i);

    // --- HEAD TUBE LUG ---
    // Using repositioned lug with origin at downtube socket cap
    // Simply orient along downtube and position at downtube end
    color(color_metal, alpha_metal)
        orient_to(bb_down_tube, ht_down_tube)
            rotate([0, 0, 180])
                translate([0, 0, down_tube_length-junction_socket_depth])
                    head_tube_lug_repositioned();

    // --- TOP TUBE ---
    // Connects from head tube lug top extension socket to seat tube mid-junction
    // Offset by extension_socket_depth at head tube end (to insert into lug)
    // and junction_socket_depth at seat tube end (to insert into mid-junction)
    color(color_plastic)
        orient_to(ht_top_tube, st_top_tube)
            translate([0, 0, -extension_socket_depth])
                for (i = [0:top_tube_sections-1])
                    translate([0, 0, i * top_tube_section_length])
                        top_tube_section(i);

    // --- SEAT TUBE ---
    // Connects from bb_seat_tube to st_top
    // Offset by -socket_depth so tube starts inside BB junction socket
    color(color_plastic)
        orient_to(bb_seat_tube, st_top)
            translate([0, 0, -junction_socket_depth])
                for (i = [0:seat_tube_sections-1])
                    translate([0, 0, i * seat_tube_section_length])
                        seat_tube_section(i);

    // --- SEAT TUBE JUNCTION (TOP) ---
    // Position so junction top is near st_top
    // stj_height = 60, so place junction at (actual_length - 60) along tube
    color(color_metal, alpha_metal)
        orient_to(bb_seat_tube, st_top)
            translate([0, 0, norm(st_top - bb_seat_tube) - 60])
                seat_tube_junction();

    // --- SEAT TUBE MID-JUNCTION ---
    // Position at 50% up seat tube for top tube connection
    color(color_metal, alpha_metal)
        orient_to(bb_seat_tube, st_top)
            translate(st_top_tube - bb_seat_tube)
                seat_tube_mid_junction();

    // --- CHAINSTAYS ---
    // Connect from bb area to dropout area
    // Offset by -socket_depth so tube starts inside BB junction socket
    color(color_plastic)
        for (side = [-1, 1])
            orient_to([0, side * cs_spread, bb_chainstay_z],
                      dropout + [0, side * cs_spread, dropout_chainstay_z])
                translate([0, 0, -junction_socket_depth])
                    for (i = [0:chainstay_sections-1])
                        translate([0, 0, i * chainstay_section_length])
                            chainstay_section(i);

    // --- SEAT STAYS ---
    // Connect from st_top area to dropout area
    // Keep at ss_spread for structural rigidity (no convergence with chainstay)
    // Tube starts at socket entrance (Z=5mm), inserts 25mm into socket
    // Tube bolt at 12.5mm from start aligns with junction bolt at Z=17.5 (socket center)
    color(color_plastic)
        for (side = [-1, 1])
            orient_to(st_top + [0, side * ss_spread, st_seat_stay_z],
                      dropout + [0, side * ss_spread, dropout_seat_stay_z])
                translate([0, 0, 5])
                    for (i = [0:seat_stay_sections-1])
                        translate([0, 0, i * seat_stay_section_length])
                            seat_stay_section(i);

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

    // --- DEBUG CYLINDERS FOR TOP TUBE SOCKET POSITION CALCULATION ---
    debug_cylinder_diameter = 5;
    debug_cylinder_length = 200;

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
