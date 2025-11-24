// Complete Ebike Frame Assembly
// Renders all components in their assembled positions

include <config.scad>

// Override $fn for assembly preview performance
$fn = fn_assembly;

// Metal transparency for geometry verification (1.0 = opaque, 0.3 = transparent)
alpha_metal = 0.3;

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
use <components/metal/dropout_junction.scad>
use <components/metal/battery_mount.scad>
use <components/metal/motor_mount.scad>
use <components/metal/brake_mount.scad>
use <components/metal/cable_guide.scad>
use <components/metal/rack_mount.scad>
use <components/plastic-cf/down_tube.scad>
use <components/plastic-cf/seat_tube.scad>
use <components/plastic-cf/chainstay.scad>
use <components/plastic-cf/seat_stay.scad>

// =============================================================================
// ASSEMBLY
// =============================================================================
module frame_assembly() {

    // --- BB JUNCTION ---
    color(color_metal, alpha_metal)
        bb_junction();

    // --- HEAD TUBE ---
    color(color_metal, alpha_metal)
        orient_to(ht_bottom, ht_top)
            head_tube();

    // --- HEAD TUBE LUG ---
    color(color_metal, alpha_metal)
        orient_to(ht_bottom, ht_top)
            head_tube_lug();

    // --- SEAT TUBE ---
    // Connects from bb_seat_tube to st_top
    // Offset by -socket_depth so tube starts inside BB junction socket
    color(color_plastic)
        orient_to(bb_seat_tube, st_top)
            translate([0, 0, -junction_socket_depth])
                for (i = [0:seat_tube_sections-1])
                    translate([0, 0, i * seat_tube_section_length])
                        seat_tube_section(i);

    // --- SEAT TUBE JUNCTION ---
    // Position so junction top is near st_top
    // stj_height = 60, so place junction at (actual_length - 60) along tube
    color(color_metal, alpha_metal)
        orient_to(bb_seat_tube, st_top)
            translate([0, 0, norm(st_top - bb_seat_tube) - 60])
                seat_tube_junction();

    // --- DOWN TUBE ---
    // Connects from ht_down_tube to bb_down_tube
    // Offset by -socket_depth so tube starts inside head tube lug socket
    color(color_plastic)
        orient_to(ht_down_tube, bb_down_tube)
            translate([0, 0, -junction_socket_depth])
                for (i = [0:down_tube_sections-1])
                    translate([0, 0, i * down_tube_section_length])
                        down_tube_section(i);

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
    // Seat tube junction collar extends outward, so tube starts at entry point (no offset)
    color(color_plastic)
        for (side = [-1, 1])
            orient_to(st_top + [0, side * ss_spread, st_seat_stay_z],
                      dropout + [0, side * ss_spread, dropout_seat_stay_z])
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

    // NOTE: Additional components (dropouts, motor mount, battery mounts,
    // brake mount, cable guides, rack mounts) removed for geometry verification.
    // Re-add once core frame geometry is confirmed correct.
}

frame_assembly();
