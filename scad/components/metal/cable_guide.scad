// Cable Guide
// CNC milled component for NestWorks C500

include <../../config.scad>

module cable_guide() {
    difference() {
        // Main body
        cube([cable_guide_length, cable_guide_width, cable_guide_height]);

        // Cable channel
        translate([-epsilon, cable_guide_width/2, cable_guide_height/2])
            rotate([0, 90, 0])
                cylinder(h = cable_guide_length + 2*epsilon, d = 6);

        // Mounting hole (M4)
        translate([cable_guide_length/2, cable_guide_width/2, -epsilon])
            cylinder(h = cable_guide_height + 2*epsilon, d = 4.5);
    }
}

// Render for preview
cable_guide();
