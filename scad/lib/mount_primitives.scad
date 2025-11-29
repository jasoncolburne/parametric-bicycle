// Mounting primitives for rivnuts and accessories

// Creates a through hole for M5 rivnut installation in carbon fiber tube
// 9mm diameter, orthogonal to tube axis
// z_position: position along tube axis in mm
module rivnut_hole(z_position) {
    rivnut_diameter = 9;  // M5 rivnut requires 9mm hole

    translate([0, 0, z_position])
        rotate([90, 0, 0])
            cylinder(d = rivnut_diameter, h = 200, center = true);  // Long enough to go through any tube
}
