// Seat Tube
// Carbon fiber reinforced - FibreSeeker 3
// Printed in 2 sections

include <../../config.scad>

// Calculate section length
seat_tube_section_length = seat_tube_length / seat_tube_sections;

module seat_tube_section(section_num) {
    difference() {
        // Outer tube
        cylinder(h = seat_tube_section_length, d = seat_tube_od);

        // Inner bore for seatpost
        translate([0, 0, -epsilon])
            cylinder(h = seat_tube_section_length + 2*epsilon, d = seat_tube_id);

        // Bolt holes for sleeve joint
        // Bottom of section (if not first)
        if (section_num > 0) {
            for (i = [0:joint_bolt_count-1]) {
                translate([0, 0, joint_overlap/2 + i * 10])
                    rotate([90, 0, 0])
                        cylinder(h = 50, d = joint_bolt_diameter + 0.5, center = true);
            }
        }

        // Top of section (if not last)
        if (section_num < seat_tube_sections - 1) {
            for (i = [0:joint_bolt_count-1]) {
                translate([0, 0, seat_tube_section_length - joint_overlap/2 - i * 10])
                    rotate([90, 0, 0])
                        cylinder(h = 50, d = joint_bolt_diameter + 0.5, center = true);
            }
        }
    }
}

// Render section (set via -D render_section=N)
render_section = 0;  // Default for preview

seat_tube_section(render_section);
