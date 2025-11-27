// Top Tube
// Carbon fiber reinforced - FibreSeeker 3
// Connects head tube lug to seat tube mid-junction
// Prints standing on end for optimal layer orientation

include <../../config.scad>

module top_tube_section(section_num) {
    difference() {
        // Main cylindrical tube
        cylinder(h = top_tube_section_length, d = top_tube_od);

        // Inner bore
        translate([0, 0, -epsilon])
            cylinder(h = top_tube_section_length + 2*epsilon,
                     d = top_tube_od - 2 * tube_wall_thickness);

        // Junction bolt holes at tube ends
        // First section: holes at start for head tube lug
        if (section_num == 0) {
            for (angle = [0, 180])
                rotate([0, 0, angle])
                    translate([0, 0, junction_socket_depth/2])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
        }

        // Last section: holes at end for seat tube mid-junction
        if (section_num == top_tube_sections - 1) {
            for (angle = [0, 180])
                rotate([0, 0, angle])
                    translate([0, 0, top_tube_section_length - junction_socket_depth/2])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
        }

        // Bolt holes for sleeve joints between sections
        if (section_num > 0) {
            for (i = [0:joint_bolt_count-1]) {
                rotate([0, 0, i * 180])
                    translate([0, 0, joint_overlap/2 + (i % 2) * 8])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
            }
        }

        if (section_num < top_tube_sections - 1) {
            for (i = [0:joint_bolt_count-1]) {
                rotate([0, 0, i * 180])
                    translate([0, 0, top_tube_section_length - joint_overlap/2 - (i % 2) * 8])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
            }
        }
    }
}

// Render section (set via -D render_section=N)
render_section = 0;  // Default for preview

top_tube_section(render_section);
