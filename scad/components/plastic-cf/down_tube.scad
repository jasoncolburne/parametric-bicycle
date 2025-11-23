// Down Tube (Step-Through with Gusset)
// Carbon fiber reinforced - FibreSeeker 3
// Printed in 2 straight sections joined by aluminum gusset
// Prints standing on end for optimal layer orientation

include <../../config.scad>

module down_tube_section(section_num) {
    difference() {
        // Outer tube - straight cylinder
        cylinder(h = down_tube_section_length, d = down_tube_od);

        // Inner bore - extends beyond ends
        translate([0, 0, -epsilon])
            cylinder(h = down_tube_section_length + 2*epsilon,
                     d = down_tube_od - 2 * tube_wall_thickness);

        // Bolt holes at bottom end (for head tube end or gusset)
        for (i = [0:joint_bolt_count-1]) {
            rotate([0, 0, i * 180])  // Opposite sides
                translate([0, 0, joint_overlap/2 + (i % 2) * 8])
                    rotate([90, 0, 0])
                        cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
        }

        // Bolt holes at top end (for gusset or BB end)
        for (i = [0:joint_bolt_count-1]) {
            rotate([0, 0, i * 180])  // Opposite sides
                translate([0, 0, down_tube_section_length - joint_overlap/2 - (i % 2) * 8])
                    rotate([90, 0, 0])
                        cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
        }
    }
}

// Render section (set via -D render_section=N)
render_section = 0;  // Default for preview

down_tube_section(render_section);
