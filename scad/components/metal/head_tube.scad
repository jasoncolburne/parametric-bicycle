// Head Tube
// CNC milled component for NestWorks C500

include <../../config.scad>

module head_tube() {
    difference() {
        // Outer cylinder
        cylinder(h = head_tube_length, d = head_tube_od);

        // Inner bore (for headset)
        translate([0, 0, -epsilon])
            cylinder(h = head_tube_length + 2*epsilon, d = head_tube_id);
    }
}

// Render for preview
head_tube();
