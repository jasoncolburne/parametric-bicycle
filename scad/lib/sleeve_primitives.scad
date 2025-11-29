// Sleeve primitives for metal components

include <bolt_sizes.scad>
include <tube_sizes.scad>

// Creates an inner metal sleeve for joining two plastic-cf tubes
// Has 4 through holes (2 per tube section) for M6/M5 bolts
module inner_sleeve(tube_size) {
    outer_r = tube_outer_radius(tube_size);
    thickness = tube_collar_thickness(tube_size);
    bolt_size = tube_bolt_size(tube_size);
    clearance_r = bolt_clearance_radius(bolt_size);

    // Standard sleeve length - fits in both socket ends
    sleeve_length = 60;
    hole_spacing = 15;  // Distance from each end to bolt hole

    difference() {
        // Sleeve cylinder
        cylinder(r = outer_r - 0.25, h = sleeve_length);  // 0.25mm clearance for fit

        // Through holes - 2 at each end (90 degrees apart for strength)
        for (z = [hole_spacing, sleeve_length - hole_spacing]) {
            for (angle = [0, 90]) {
                rotate([0, 0, angle])
                    translate([outer_r / 2, 0, z])
                        rotate([90, 0, 0])
                            cylinder(r = clearance_r, h = outer_r * 2, center = true);
            }
        }
    }
}
