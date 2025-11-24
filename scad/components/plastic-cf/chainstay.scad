// Chainstay
// Carbon fiber reinforced - FibreSeeker 3
// Printed in 2 sections
// Note: 2 required (left and right)

include <../../config.scad>

// Note: chainstay_section_length is defined in config.scad

module chainstay_section(section_num) {
    // Calculate taper for this section
    start_ratio = section_num / chainstay_sections;
    end_ratio = (section_num + 1) / chainstay_sections;

    // BB end is larger (26mm), dropout end is standard (22mm)
    start_od = chainstay_od + 4 * (1 - start_ratio);
    end_od = chainstay_od + 4 * (1 - end_ratio);

    start_id = start_od - 2*chainstay_wall;
    end_id = end_od - 2*chainstay_wall;

    difference() {
        // Outer tube - tapered using cylinder with d1/d2
        cylinder(h = chainstay_section_length, d1 = start_od, d2 = end_od);

        // Inner bore - tapered, extends beyond ends
        translate([0, 0, -epsilon])
            cylinder(h = chainstay_section_length + 2*epsilon, d1 = start_id, d2 = end_id);

        // Junction bolt holes at tube ends (for through-bolts in junction sockets)
        // First section: holes at start for BB junction
        if (section_num == 0) {
            for (angle = [0, 180])
                rotate([0, 0, angle])
                    translate([0, 0, junction_socket_depth/2])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
        }

        // Last section: holes at end for dropout junction
        if (section_num == chainstay_sections - 1) {
            for (angle = [0, 180])
                rotate([0, 0, angle])
                    translate([0, 0, chainstay_section_length - junction_socket_depth/2])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
        }

        // Bolt holes for sleeve joint between sections
        if (section_num > 0) {
            for (i = [0:joint_bolt_count-1]) {
                rotate([0, 0, i * 180])  // Opposite sides
                    translate([0, 0, joint_overlap/2 + (i % 2) * 8])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
            }
        }

        if (section_num < chainstay_sections - 1) {
            for (i = [0:joint_bolt_count-1]) {
                rotate([0, 0, i * 180])  // Opposite sides
                    translate([0, 0, chainstay_section_length - joint_overlap/2 - (i % 2) * 8])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
            }
        }
    }
}

// Render section (set via -D render_section=N)
render_section = 0;  // Default for preview

chainstay_section(render_section);
