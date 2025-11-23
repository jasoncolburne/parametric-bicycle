// Down Tube (Step-Through Curved)
// Carbon fiber reinforced - FibreSeeker 3
// Printed in 3 sections

include <../../config.scad>

// Calculate section length
down_tube_section_length = down_tube_length / down_tube_sections;

module down_tube_section(section_num) {
    // Each section is a portion of the curved tube
    arc_angle = (down_tube_length / down_tube_curve_radius) * (180 / PI);
    section_angle = arc_angle / down_tube_sections;
    start_angle = section_num * section_angle;

    difference() {
        rotate_extrude(angle = section_angle, $fn = 128)
            translate([down_tube_curve_radius, 0, 0])
                circle(d = down_tube_od);

        rotate_extrude(angle = section_angle, $fn = 128)
            translate([down_tube_curve_radius, 0, 0])
                circle(d = down_tube_od - 2 * tube_wall_thickness);

        // Bolt holes for sleeve joint (if not first section)
        if (section_num > 0) {
            // Entry end bolt holes
            for (i = [0:joint_bolt_count-1]) {
                rotate([0, 0, section_angle * 0.1])
                    translate([down_tube_curve_radius, 0, 0])
                        rotate([90, 0, 0])
                            cylinder(h = 50, d = joint_bolt_diameter + 0.5, center = true);
            }
        }

        // Exit end bolt holes (if not last section)
        if (section_num < down_tube_sections - 1) {
            for (i = [0:joint_bolt_count-1]) {
                rotate([0, 0, section_angle * 0.9])
                    translate([down_tube_curve_radius, 0, 0])
                        rotate([90, 0, 0])
                            cylinder(h = 50, d = joint_bolt_diameter + 0.5, center = true);
            }
        }
    }
}

// Render section (set via -D render_section=N)
render_section = 0;  // Default for preview

down_tube_section(render_section);
