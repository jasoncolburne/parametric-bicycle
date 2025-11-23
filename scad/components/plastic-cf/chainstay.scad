// Chainstay
// Carbon fiber reinforced - FibreSeeker 3
// Printed in 2 sections
// Note: 2 required (left and right)

include <../../config.scad>

// Calculate section length
chainstay_section_length = chainstay_length / chainstay_sections;

module chainstay_section(section_num) {
    // Calculate taper for this section
    start_ratio = section_num / chainstay_sections;
    end_ratio = (section_num + 1) / chainstay_sections;

    // BB end is larger (26mm), dropout end is standard (22mm)
    start_od = chainstay_od + 4 * (1 - start_ratio);
    end_od = chainstay_od + 4 * (1 - end_ratio);

    difference() {
        // Outer tube - tapered
        hull() {
            cylinder(h = 1, d = start_od);
            translate([0, 0, chainstay_section_length - 1])
                cylinder(h = 1, d = end_od);
        }

        // Inner bore - tapered
        hull() {
            translate([0, 0, -epsilon])
                cylinder(h = 1, d = start_od - 2*chainstay_wall);
            translate([0, 0, chainstay_section_length - 1])
                cylinder(h = 1 + epsilon, d = end_od - 2*chainstay_wall);
        }

        // Bolt holes for sleeve joint
        if (section_num > 0) {
            for (i = [0:joint_bolt_count-1]) {
                translate([0, 0, joint_overlap/2 + i * 10])
                    rotate([90, 0, 0])
                        cylinder(h = 50, d = joint_bolt_diameter + 0.5, center = true);
            }
        }

        if (section_num < chainstay_sections - 1) {
            for (i = [0:joint_bolt_count-1]) {
                translate([0, 0, chainstay_section_length - joint_overlap/2 - i * 10])
                    rotate([90, 0, 0])
                        cylinder(h = 50, d = joint_bolt_diameter + 0.5, center = true);
            }
        }
    }
}

// Render section (set via -D render_section=N)
render_section = 0;  // Default for preview

chainstay_section(render_section);
