// Complete Ebike Frame Assembly
// Renders all components in their assembled positions

include <config.scad>

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
use <components/plastic-cf/down_tube.scad>
use <components/plastic-cf/seat_tube.scad>
use <components/plastic-cf/chainstay.scad>
use <components/plastic-cf/seat_stay.scad>

// =============================================================================
// ASSEMBLY
// =============================================================================
module frame_assembly() {

    // --- BB JUNCTION (replaces standalone BB shell) ---
    color(color_metal)
        bb_junction();

    // --- HEAD TUBE ---
    color(color_metal)
        orient_to(ht_bottom, ht_top)
            head_tube();

    // --- HEAD TUBE LUG ---
    color(color_metal)
        orient_to(ht_bottom, ht_top)
            head_tube_lug();

    // --- SEAT TUBE ---
    color(color_plastic)
        orient_to(bb, st_top)
            for (i = [0:seat_tube_sections-1])
                translate([0, 0, i * seat_tube_section_length])
                    seat_tube_section(i);

    // --- SEAT TUBE JUNCTION (replaces seat collar) ---
    color(color_metal)
        orient_to(bb, st_top)
            translate([0, 0, seat_tube_length - 50])
                seat_tube_junction();

    // --- DOWN TUBE ---
    color(color_plastic)
        orient_to(ht_bottom, bb)
            for (i = [0:down_tube_sections-1])
                translate([0, 0, i * down_tube_section_length])
                    down_tube_section(i);

    // --- CHAINSTAYS ---
    color(color_plastic)
        for (side = [-1, 1])
            orient_to(bb + [0, side * cs_spread, 0], dropout + [0, side * cs_spread, 0])
                for (i = [0:chainstay_sections-1])
                    translate([0, 0, i * chainstay_section_length])
                        chainstay_section(i);

    // --- SEAT STAYS ---
    color(color_plastic)
        for (side = [-1, 1])
            orient_to(st_top + [0, side * ss_spread, 0], dropout + [0, side * ss_spread, 0])
                for (i = [0:seat_stay_sections-1])
                    translate([0, 0, i * seat_stay_section_length])
                        seat_stay_section(i);

    // --- DROPOUT JUNCTIONS ---
    color(color_metal)
        for (side = [-1, 1]) {
            translate(dropout + [0, side * cs_spread, 0])
                dropout_junction();
        }
}

frame_assembly();
