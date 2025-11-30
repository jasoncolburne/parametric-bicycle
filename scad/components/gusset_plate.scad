// Head Tube Gusset Plate
// CNC milled component for NestWorks C500
// Reinforces head tube junction for step-through frame

include <../geometry.scad>

module gusset_plate() {
    difference() {
        // Triangular gusset shape
        linear_extrude(height = gusset_thickness) {
            polygon(points = [
                [0, 0],
                [gusset_width, 0],
                [gusset_width, gusset_height * 0.3],
                [gusset_width * 0.3, gusset_height],
                [0, gusset_height]
            ]);
        }

        // Head tube clearance
        translate([0, gusset_height/2, -epsilon])
            cylinder(h = gusset_thickness + 2*epsilon, d = head_tube_od + 2);

        // Mounting holes (M5)
        translate([gusset_width - 15, 15, -epsilon])
            cylinder(h = gusset_thickness + 2*epsilon, d = 5.5);
        translate([15, gusset_height - 15, -epsilon])
            cylinder(h = gusset_thickness + 2*epsilon, d = 5.5);
    }
}

// Render for preview
gusset_plate();
