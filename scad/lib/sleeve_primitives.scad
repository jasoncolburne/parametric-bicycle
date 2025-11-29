// Sleeve primitives for metal components

include <bolt_sizes.scad>
include <tube_sizes.scad>
include <collar.scad>
include <helpers.scad>

// Creates a metal sleeve around a tube with options for collars
// Combines base sleeve cylinder with multiple oriented collars
module sleeve(tube_size, height, collars) {
    outer_r = tube_outer_radius(tube_size);
    thickness = tube_collar_thickness(tube_size);
    clearance = tube_socket_clearance(tube_size);

    difference() {
        union() {
            // Base sleeve cylinder
            cylinder(r = outer_r + thickness, h = height);  // Default 100mm sleeve length

            // Add all collars
            for (collar = collars) {
                sleeve_collar(collar);
            }
        }
    
        translate([0, 0, -height])
            cylinder(r = outer_r + clearance, h = 3 * height);
    }
}

// Creates an inner metal sleeve for joining two plastic-cf tubes
// Has 4 through holes (2 per tube section) for M6/M5 bolts
module inner_sleeve(tube_size) {
    outer_r = tube_outer_radius(tube_size);
    tube_thickness = tube_thickness(tube_size);
    half_length = tube_inner_sleeve_depth(tube_size);
    thickness = tube_inner_sleeve_thickness(tube_size);
    bolt_size = tube_bolt_size(tube_size);
    clearance = tube_inner_sleeve_clearance(tube_size);
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

        translate([0, 0, -0.01])
            cylinder(r = outer_r - tube_thickness - thickness - clearance, h = sleeve_length + 0.02);
    }
}

// Creates a tubular extension with socket bore for tube insertion
// Uses Collar struct for configuration (tube_size, rotation, height)
module sleeve_collar(collar) {
    tube_size = collar_tube_size(collar);
    rotation = collar_rotation(collar);
    height = collar_height(collar);

    outer_r = tube_outer_radius(tube_size);
    socket_depth = tube_socket_depth(tube_size);
    socket_clearance = tube_socket_clearance(tube_size);
    extension_depth = tube_extension_depth(tube_size);
    collar_thickness = tube_collar_thickness(tube_size);
    bolt_size = tube_bolt_size(tube_size);

    tap_r = bolt_tap_radius(bolt_size);
    clearance_r = bolt_clearance_radius(bolt_size);
    counterbore_r = bolt_counterbore_radius(bolt_size);
    counterbore_d = bolt_counterbore_depth(bolt_size);
    boss_r = bolt_boss_radius(bolt_size);

    // Position and orient collar
    translate([0, 0, height])
        rotate(rotation) {
            difference() {
                union() {
                    // Extension cylinder
                    cylinder(r = outer_r + collar_thickness, h = extension_depth);

                    // Spherical boss on tap side
                    translate([0, 0, extension_depth - socket_depth + socket_depth/2])
                        rotate([90, 0, 0])
                            translate([0, 0, outer_r + collar_thickness])
                                sphere(r = boss_r);
                }

                // Socket bore
                translate([0, 0, extension_depth - socket_depth])
                    cylinder(r = outer_r + socket_clearance/2, h = socket_depth + 0.01);

                // Through-bolt holes (M6 or M5)
                translate([0, 0, extension_depth - socket_depth + socket_depth/2])
                    rotate([90, 0, 0]) {
                        // Tap hole from one side
                        translate([0, 0, outer_r + socket_clearance/2 - 2])
                            cylinder(r = tap_r, h = 12);

                        // Clearance hole from opposite side
                        translate([0, 0, -(outer_r + collar_thickness)])
                            cylinder(r = clearance_r,
                                    h = outer_r + collar_thickness - (outer_r + socket_clearance/2 - 2));

                        // Counterbore for socket head
                        translate([0, 0, -(outer_r + collar_thickness)])
                            cylinder(r = counterbore_r, h = counterbore_d);
                    }
            }
        }
}

// Creates a pinch bolt boss for sleeve clamping
// Separated by a split plane for pinch clamp action
module sleeve_pinch_bolt(bolt_size, bolt_length, separation) {
    tap_r = bolt_tap_radius(bolt_size);
    clearance_r = bolt_clearance_radius(bolt_size);
    counterbore_r = bolt_counterbore_radius(bolt_size);
    counterbore_d = bolt_counterbore_depth(bolt_size);
    boss_r = bolt_boss_radius(bolt_size);

    difference() {
        // Spherical boss
        sphere(r = boss_r);

        // Split plane (gap for pinch action)
        translate([0, -separation/2, -boss_r])
            cube([boss_r * 3, separation, boss_r * 2], center = true);

        // Tap hole through center
        cylinder(r = tap_r, h = bolt_length, center = true);

        // Counterbore on one side
        translate([0, 0, -bolt_length/2])
            cylinder(r = counterbore_r, h = counterbore_d);
    }
}
