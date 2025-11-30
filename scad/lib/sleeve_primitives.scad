// Sleeve primitives for metal components

include <bolt_sizes.scad>
include <tube_sizes.scad>
include <collar.scad>
include <helpers.scad>

// Creates a metal sleeve around a tube with options for collars
// Combines base sleeve cylinder with multiple oriented collars
module sleeve(tube_size, height, collars, debug_color = "invisible", body_color = "silver", alpha = 1.0) {
    outer_r = tube_outer_radius(tube_size);
    thickness = tube_collar_thickness(tube_size);
    clearance = tube_socket_clearance(tube_size);

    difference() {
        union() {
            // Base sleeve cylinder
            color(body_color, alpha)
                cylinder(r = outer_r + thickness, h = height);

            // Add all collars
            for (collar = collars) {
                sleeve_collar(collar, operation = "positive", debug_color = debug_color, body_color = body_color, alpha = alpha);
            }

            // Allow injection of additional geometry (bosses, bolts)
            color(body_color, alpha)
                children();
        }

        // Add all collars
        for (collar = collars) {
            sleeve_collar(collar, operation = "negative");
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

        translate([0, 0, -sleeve_length])
            cylinder(r = outer_r - tube_thickness - thickness - clearance, h = sleeve_length * 3);
    }
}

// Creates a tubular extension with socket bore for tube insertion
// Uses Collar struct for configuration (tube_size, rotation, height)
module sleeve_collar(collar, operation = "both", debug_color = "invisible", body_color = "silver", alpha = 1.0) {
    tube_size = collar_tube_size(collar);
    rotation = collar_rotation(collar);
    height = collar_height(collar);
    translation = collar_translation(collar);
    cap = collar_cap(collar);

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
    translate(translation + [0, 0, height])
        rotate(rotation) {
            difference() {
                if (operation == "both" || operation == "positive") {
                    color(body_color, alpha) {
                        union() {
                            // Extension cylinder
                            cylinder(r = outer_r + collar_thickness, h = extension_depth);

                            // Spherical boss on tap side
                            translate([0, 0, extension_depth - socket_depth + socket_depth/2])
                                rotate([0, 90, 0])
                                    translate([0, 0, outer_r + collar_thickness])
                                        sphere(r = boss_r);

                            if (cap) {
                                sphere(r = outer_r + collar_thickness);
                            }
                        }
                    }
                }

                if (operation == "both" || operation == "negative") {
                    // Socket bore
                    translate([0, 0, extension_depth - socket_depth])
                        cylinder(r = outer_r + socket_clearance, h = 2 * socket_depth);

                    // Through-bolt holes (M6 or M5)
                    translate([0, 0, extension_depth - socket_depth + socket_depth/2])
                        rotate([0, 90, 0]) {
                            // Tap hole from one side
                            translate([0, 0, outer_r + socket_clearance])
                                cylinder(r = tap_r, h = 9);

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

            // Debug cylinder at socket entrance
            if (debug_color != "invisible") {
                debug_cylinder_d = 5;
                debug_cylinder_length = 200;

                translate([0, 0, extension_depth - socket_depth])
                    color(debug_color, 0.8)
                        rotate([90, 0, 0])
                            cylinder(h = debug_cylinder_length, d = debug_cylinder_d, center = true);
            }
        }
}

// Creates a pinch bolt boss for sleeve clamping
// Separated by a split plane for pinch clamp action
module sleeve_pinch_bolt(bolt_size, bolt_length, separation, operation = "both") {
    tap_r = bolt_tap_radius(bolt_size);
    clearance_r = bolt_clearance_radius(bolt_size);
    boss_r = bolt_boss_radius(bolt_size);

    height = bolt_length - boss_r / 2;
    difference() {
        if (operation == "both" || operation == "positive") {
            union() {
                translate([0, 0, height / 2])
                    sphere(r = boss_r);
                    
                cylinder(r = boss_r, h = height, center = true);
            }
        }

        if (operation == "both" || operation == "negative") {
            rotate([180, 0, 0])
                translate([0, 0, height / 2])
                    cylinder(r = boss_r, h = height * 3);            

            // Split plane (gap for pinch action)
            cube([boss_r * 3, boss_r * 3, separation], center = true);

            // Tap hole through center
            cylinder(r = tap_r, h = bolt_length, center = true);

            // Clearance hole on one side
            rotate([180, 0, 0])
                cylinder(r = clearance_r, h = height);
        }
    }    
}

module transform_pinch_bolt(height, radius) {
    translate([0, 0, height])
        rotate([90, 0, 0])
            translate([0, 0, radius])
                rotate([0, 90, 180])
                    children();
}

// Creates a pinched sleeve for clamp mounting with stepped bore
// Uses difference() to subtract pinch slot from base sleeve
// upper_tube_size: bore size above the pinch slot (clamping section)
// lower_tube_size: bore size below the pinch slot (structural section)
module pinched_sleeve(upper_tube_size, lower_tube_size, height, pinch_slot_depth, collars, bolt_count, debug_color = "invisible", body_color = "silver", alpha = 1.0) {
    outer_r = tube_outer_radius(lower_tube_size);
    thickness = tube_collar_thickness(lower_tube_size);
    separation = tube_pinch_separation(lower_tube_size);
    bolt_size = tube_bolt_size(lower_tube_size);
    bolt_unit = pinch_slot_depth / (bolt_count + 1);

    // Split height is where pinch slot begins
    split_height = height - pinch_slot_depth;

    // Bore sizes
    upper_bore_r = tube_outer_radius(upper_tube_size) + tube_socket_clearance(upper_tube_size);
    lower_bore_r = tube_outer_radius(lower_tube_size) + tube_socket_clearance(lower_tube_size);

    difference() {
        union() {
            // Base sleeve with pinch bolt as child
            sleeve(lower_tube_size, height, collars, debug_color, body_color, alpha) {
                for (i = [1:bolt_count]) {
                    // Pinch bolt positioned at pinch slot
                    transform_pinch_bolt(height - pinch_slot_depth + bolt_unit * i, outer_r + thickness * 3 / 4)
                        sleeve_pinch_bolt(bolt_size, outer_r, separation, operation = "positive");
                }
            }

            color(body_color, alpha)
                translate([0, 0, split_height])
                    cylinder(r = lower_bore_r, h = pinch_slot_depth);
        }

        // Upper bore (above split) - typically smaller diameter for seating
        translate([0, 0, split_height])
            cylinder(r = upper_bore_r, h = pinch_slot_depth * 2);

        // Pinch slot (vertical cut through sleeve wall)
        translate([-separation / 2, -(outer_r + thickness + 0.01), height - pinch_slot_depth])
            cube([separation, outer_r + thickness + 0.01, pinch_slot_depth * 2]);

        for (i = [1:bolt_count]) {
            transform_pinch_bolt(height - pinch_slot_depth + bolt_unit * i, outer_r + thickness * 3 / 4)
                sleeve_pinch_bolt(bolt_size, outer_r, separation, operation = "negative");
        }
    }
}

// Creates a tapped sleeve for bolt mounting
// Passes bosses and bolt holes as children to base sleeve
module tapped_sleeve(tube_size, height, taps, collars, debug_color = "invisible", body_color = "silver", alpha = 1.0) {
    outer_r = tube_outer_radius(tube_size);
    thickness = tube_collar_thickness(tube_size);
    bolt_size = tube_bolt_size(tube_size);

    tap_r = bolt_tap_radius(bolt_size);
    clearance_r = bolt_clearance_radius(bolt_size);
    counterbore_r = bolt_counterbore_radius(bolt_size);
    counterbore_d = bolt_counterbore_depth(bolt_size);
    boss_r = bolt_boss_radius(bolt_size);

    difference() {
        // Base sleeve with bosses as children
        sleeve(tube_size, height, collars, debug_color, body_color, alpha) {
            // Add bosses at each tap position
            for (z = taps) {
                translate([outer_r + thickness, 0, z])
                    sphere(r = boss_r);
            }
        }

        // Through-bolt holes at each tap position
        for (z = taps) {
            translate([0, 0, z])
                rotate([0, 90, 0]) {
                    // Tap hole from inner side
                    translate([0, 0, outer_r - 2])
                        cylinder(r = tap_r, h = 12);

                    // Clearance hole from opposite side
                    translate([0, 0, -(outer_r + thickness)])
                        cylinder(r = clearance_r,
                                h = (outer_r + thickness) - (outer_r - 2));

                    // Counterbore for socket head
                    translate([0, 0, -(outer_r + thickness)])
                        cylinder(r = counterbore_r, h = counterbore_d);
                }
        }
    }
}
