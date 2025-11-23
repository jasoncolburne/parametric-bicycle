// Down Tube (Step-Through Curved)
// Carbon fiber reinforced - FibreSeeker 3
// Printed in 3 sections with lap/flange joints

include <../../config.scad>

// Calculate section arc angle
arc_angle = (down_tube_length / down_tube_curve_radius) * (180 / PI);
section_angle = arc_angle / down_tube_sections;

// Overlap angle for lap joint
overlap_angle = (lap_overlap / down_tube_curve_radius) * (180 / PI);

module down_tube_section(section_num) {
    difference() {
        union() {
            // Main tube section
            rotate_extrude(angle = section_angle, $fn = 128)
                translate([down_tube_curve_radius, 0, 0])
                    difference() {
                        circle(d = down_tube_od);
                        circle(d = down_tube_od - 2 * tube_wall_thickness);
                    }

            // Expanded collar at exit end for lap joint (if not last section)
            if (section_num < down_tube_sections - 1) {
                rotate([0, 0, section_angle])
                    rotate_extrude(angle = overlap_angle, $fn = 128)
                        translate([down_tube_curve_radius, 0, 0])
                            difference() {
                                circle(d = down_tube_od + 6);  // Expanded OD for overlap
                                circle(d = down_tube_od);      // Fits over next section
                            }
            }
        }

        // Bolt holes for flange clamps at entry end (if not first section)
        if (section_num > 0) {
            // 4 bolt holes arranged in 2 pairs
            for (z_angle = [0.5, 1.5]) {
                for (radial_angle = [30, -30]) {
                    rotate([0, 0, z_angle])
                        translate([down_tube_curve_radius, 0, 0])
                            rotate([radial_angle, 0, 0])
                                rotate([0, 90, 0])
                                    cylinder(h = 50, d = flange_bolt_diameter + 0.5, center = true);
                }
            }
        }

        // Bolt holes for flange clamps at exit end (if not last section)
        if (section_num < down_tube_sections - 1) {
            for (z_angle = [section_angle + overlap_angle/3, section_angle + overlap_angle*2/3]) {
                for (radial_angle = [30, -30]) {
                    rotate([0, 0, z_angle])
                        translate([down_tube_curve_radius, 0, 0])
                            rotate([radial_angle, 0, 0])
                                rotate([0, 90, 0])
                                    cylinder(h = 50, d = flange_bolt_diameter + 0.5, center = true);
                }
            }
        }
    }
}

// Render section (set via -D render_section=N)
render_section = 0;  // Default for preview

down_tube_section(render_section);
