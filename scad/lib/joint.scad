// Joint primitives for tube connections

include <bolt_sizes.scad>
include <tube_sizes.scad>

// Creates an inner metal sleeve for joining two plastic-cf tubes
// Has 4 through holes (2 per tube section) for M6/M5 bolts
module joint(tube_size) {
    outer_r = tube_outer_radius(tube_size);
    tube_thickness = tube_thickness(tube_size);
    half_length = tube_joint_depth(tube_size);
    thickness = tube_joint_thickness(tube_size);
    bolt_size = tube_bolt_size(tube_size);
    clearance = tube_joint_clearance(tube_size);
    through_r = bolt_through_radius(bolt_size);

    // Standard sleeve length - fits in both socket ends
    sleeve_length = half_length * 2;

    difference() {
        // Sleeve cylinder
        cylinder(r = outer_r - tube_thickness - clearance, h = sleeve_length);

        // Through holes - 2 at each end (90 degrees apart for strength)
        hole_height_unit = sleeve_length / 6;
        for (x = [1, 4]) {
            translate([0, 0, hole_height_unit * x])
                rotate([90, 0, 0])
                    cylinder(r = through_r, h = outer_r * 3, center = true);

            rotate([0, 0, 90])
                translate([0, 0, hole_height_unit * (x + 1)])
                    rotate([90, 0, 0])
                        cylinder(r = through_r, h = outer_r * 3, center = true);
        }

        translate([0, 0, -sleeve_length])
            cylinder(r = outer_r - tube_thickness - thickness - clearance, h = sleeve_length * 3);
    }
}
