// Down Tube (Step-Through with Gusset)
// Carbon fiber reinforced - FibreSeeker 3
// Printed in 2 straight sections joined by aluminum gusset
// Prints standing on end for optimal layer orientation

include <../../config.scad>

module down_tube_section(section_num) {
    // Mounting rail parameters
    rail_diameter = 4;           // Diameter of mounting rail cylinders (smaller)
    rail_separation = 12;        // Distance between rail centers (closer together)
    rail_offset = down_tube_od/2 - 1; // Distance from tube center (closer to surface)
    rail_length = down_tube_section_length; // Full section length

    union() {
        // Main cylindrical tube
        difference() {
            cylinder(h = down_tube_section_length, d = down_tube_od);

            // Inner bore - extends beyond ends
            translate([0, 0, -epsilon])
                cylinder(h = down_tube_section_length + 2*epsilon,
                         d = down_tube_od - 2 * tube_wall_thickness);

            // Junction bolt holes at tube ends (for through-bolts in junction sockets)
        // First section: holes at start for head tube lug
        if (section_num == 0) {
            for (angle = [0, 180])
                rotate([0, 0, angle])
                    translate([0, 0, junction_socket_depth/2])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
        }

        // Last section: holes at end for BB junction
        if (section_num == down_tube_sections - 1) {
            for (angle = [0, 180])
                rotate([0, 0, angle])
                    translate([0, 0, down_tube_section_length - junction_socket_depth/2])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
        }

        // Bolt holes for sleeve joint/gusset between sections
        if (section_num > 0) {
            for (i = [0:joint_bolt_count-1]) {
                rotate([0, 0, i * 180])  // Opposite sides
                    translate([0, 0, joint_overlap/2 + (i % 2) * 8])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
            }
        }

        if (section_num < down_tube_sections - 1) {
            for (i = [0:joint_bolt_count-1]) {
                rotate([0, 0, i * 180])  // Opposite sides
                    translate([0, 0, down_tube_section_length - joint_overlap/2 - (i % 2) * 8])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
            }
        }
        }

        // Battery mounting rails - only on middle section (section 1)
        // Rails positioned at bottom of tube (negative Z when oriented in assembly)
        if (section_num == 1) {
            // Left mounting rail (bottom-left)
            rotate([0, 0, -90])
                translate([-rail_separation/2, -rail_offset, 0]) {
                    // Cylinder connecting the spheres
                    translate([0, 0, rail_diameter/2])
                        cylinder(h = rail_length - rail_diameter, d = rail_diameter);
                    // Round bottom end (inset by radius)
                    translate([0, 0, rail_diameter/2])
                        sphere(d = rail_diameter);
                    // Round top end (inset by radius)
                    translate([0, 0, rail_length - rail_diameter/2])
                        sphere(d = rail_diameter);
                }

            // Right mounting rail (bottom-right)
            rotate([0, 0, -90])
                translate([rail_separation/2, -rail_offset, 0]) {
                    // Cylinder connecting the spheres
                    translate([0, 0, rail_diameter/2])
                        cylinder(h = rail_length - rail_diameter, d = rail_diameter);
                    // Round bottom end (inset by radius)
                    translate([0, 0, rail_diameter/2])
                        sphere(d = rail_diameter);
                    // Round top end (inset by radius)
                    translate([0, 0, rail_length - rail_diameter/2])
                        sphere(d = rail_diameter);
                }
        }
    }
}

// Render section (set via -D render_section=N)
render_section = 1;  // Default for preview

down_tube_section(render_section);
