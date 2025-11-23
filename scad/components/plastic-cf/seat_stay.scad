// Seat Stay
// Carbon fiber reinforced - FibreSeeker 3
// Printed in 2 sections
// Note: 2 required (left and right)

include <../../config.scad>

// Calculate section length
seat_stay_section_length = seat_stay_length / seat_stay_sections;

module seat_stay_section(section_num) {
    difference() {
        // Outer tube - solid cylinder
        cylinder(h = seat_stay_section_length, d = seat_stay_od);

        // Inner bore - extends beyond ends
        translate([0, 0, -epsilon])
            cylinder(h = seat_stay_section_length + 2*epsilon, d = seat_stay_od - 2*seat_stay_wall);

        // Bolt holes for sleeve joint - properly spaced around tube
        if (section_num > 0) {
            for (i = [0:joint_bolt_count-1]) {
                rotate([0, 0, i * 180])  // Opposite sides
                    translate([0, 0, joint_overlap/2 + (i % 2) * 8])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
            }
        }

        if (section_num < seat_stay_sections - 1) {
            for (i = [0:joint_bolt_count-1]) {
                rotate([0, 0, i * 180])  // Opposite sides
                    translate([0, 0, seat_stay_section_length - joint_overlap/2 - (i % 2) * 8])
                        rotate([90, 0, 0])
                            cylinder(h = bolt_hole_length, d = joint_bolt_diameter + 0.5, center = true);
            }
        }
    }
}

// Render section (set via -D render_section=N)
render_section = 0;  // Default for preview

seat_stay_section(render_section);
