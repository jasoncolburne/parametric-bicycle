// Tube primitives for plastic-cf components

include <bolt_sizes.scad>
include <tube_sizes.scad>

// Creates a simple plastic-cf tube with optional through holes
// through_holes: array of Z positions along tube axis for orthogonal holes
module tube_core(tube_size, length, through_holes = []) {
    outer_r = tube_outer_radius(tube_size);
    thickness = tube_thickness(tube_size);
    bolt_size = tube_bolt_size(tube_size);
    through_r = bolt_through_radius(bolt_size);

    difference() {
        // Main tube cylinder
        cylinder(r = outer_r, h = length);

        // Bore (hollow interior)
        translate([0, 0, -0.01])
            cylinder(r = outer_r - thickness, h = length + 0.02);

        // Through holes (orthogonal to tube axis)
        for (z = through_holes) {
            translate([0, 0, z])
                rotate([90, 0, 0])
                    cylinder(r = through_r, h = outer_r * 3, center = true);
        }
    }
}
