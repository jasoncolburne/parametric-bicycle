// Seat Tube
// Carbon fiber reinforced - FibreSeeker 3
// Printed in 2 sections

include <../../config.scad>

// Note: seat_tube_section_length is defined in config.scad

module seat_tube_section(section_num) {
    difference() {
        // Outer tube - solid cylinder
        cylinder(h = seat_tube_section_length, d = seat_tube_od);

        // Inner bore for seatpost - extends beyond ends to ensure clean cut
        translate([0, 0, -epsilon])
            cylinder(h = seat_tube_section_length + 2*epsilon, d = seat_tube_id);

        // Junction bolt holes at tube ends (for through-bolts in junction sockets)
        // First section: holes at start for BB junction
        if (section_num == 0) {
            for (angle = [0, 180])
                rotate([0, 0, angle])
                    translate([0, 0, junction_socket_depth/2])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
        }

        // Last section: holes at end for seat tube junction
        if (section_num == seat_tube_sections - 1) {
            for (angle = [0, 180])
                rotate([0, 0, angle])
                    translate([0, 0, seat_tube_section_length - junction_socket_depth/2])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
        }

        // Bolt holes for sleeve joint between sections
        // Bottom of section (if not first)
        if (section_num > 0) {
            for (i = [0:joint_bolt_count-1]) {
                rotate([0, 0, i * 180])  // Opposite sides
                    translate([0, 0, joint_overlap/2 + (i % 2) * 8])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
            }
        }

        // Top of section (if not last)
        if (section_num < seat_tube_sections - 1) {
            for (i = [0:joint_bolt_count-1]) {
                rotate([0, 0, i * 180])  // Opposite sides
                    translate([0, 0, seat_tube_section_length - joint_overlap/2 - (i % 2) * 8])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
            }
        }
    }
}

// Render section (set via -D render_section=N)
render_section = 0;  // Default for preview

seat_tube_section(render_section);
