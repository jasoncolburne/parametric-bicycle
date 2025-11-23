// Rear Dropout
// CNC milled component for NestWorks C500

include <../../config.scad>

module dropout() {
    difference() {
        // Main body
        cube([dropout_width, dropout_height, dropout_thickness]);

        // Axle hole
        translate([dropout_width/2, dropout_height - 20, -epsilon])
            cylinder(h = dropout_thickness + 2*epsilon, d = dropout_axle_diameter);

        // Chainstay mounting holes (2x M5)
        translate([dropout_width/2 - 10, 15, -epsilon])
            cylinder(h = dropout_thickness + 2*epsilon, d = 5.5);
        translate([dropout_width/2 + 10, 15, -epsilon])
            cylinder(h = dropout_thickness + 2*epsilon, d = 5.5);

        // Seat stay mounting hole (M5)
        translate([dropout_width/2, dropout_height - 50, -epsilon])
            cylinder(h = dropout_thickness + 2*epsilon, d = 5.5);

        // Derailleur hanger mount (M10)
        translate([dropout_width - 10, dropout_height - 25, -epsilon])
            cylinder(h = dropout_thickness + 2*epsilon, d = 10);
    }
}

// Render for preview
dropout();
