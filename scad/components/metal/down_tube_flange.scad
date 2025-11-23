// Down Tube Flange Plate
// CNC milled component for NestWorks C500
// Used in pairs to clamp lap-jointed tube sections

include <../../config.scad>

module down_tube_flange() {
    difference() {
        // Main plate with tube cutout
        linear_extrude(height = flange_thickness) {
            difference() {
                // Rounded rectangle body
                hull() {
                    translate([flange_thickness/2, flange_thickness/2])
                        circle(r = flange_thickness/2);
                    translate([flange_width - flange_thickness/2, flange_thickness/2])
                        circle(r = flange_thickness/2);
                    translate([flange_thickness/2, flange_height - flange_thickness/2])
                        circle(r = flange_thickness/2);
                    translate([flange_width - flange_thickness/2, flange_height - flange_thickness/2])
                        circle(r = flange_thickness/2);
                }

                // Tube cutout (semicircle for clamping)
                translate([flange_width/2, 0])
                    circle(d = down_tube_od + 1);  // Slight clearance
            }
        }

        // Bolt holes - 4 corners
        bolt_inset = 10;

        // Bottom left
        translate([bolt_inset, bolt_inset, -epsilon])
            cylinder(h = flange_thickness + 2*epsilon, d = flange_bolt_diameter + 0.5);

        // Bottom right
        translate([flange_width - bolt_inset, bolt_inset, -epsilon])
            cylinder(h = flange_thickness + 2*epsilon, d = flange_bolt_diameter + 0.5);

        // Top left
        translate([bolt_inset, flange_height - bolt_inset, -epsilon])
            cylinder(h = flange_thickness + 2*epsilon, d = flange_bolt_diameter + 0.5);

        // Top right
        translate([flange_width - bolt_inset, flange_height - bolt_inset, -epsilon])
            cylinder(h = flange_thickness + 2*epsilon, d = flange_bolt_diameter + 0.5);
    }
}

// Render for preview
down_tube_flange();
