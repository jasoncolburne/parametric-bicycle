// Seat Tube Mid Junction
// CNC milled aluminum for NestWorks C500
// Connects top tube to seat tube at calculated position
// Sleeve clamps onto seat tube with through bolt

include <../../config.scad>

// Junction dimensions
stmj_height = 40;            // Height of junction sleeve on seat tube
stmj_wall = 6;               // Wall thickness around seat tube

module seat_tube_mid_junction() {
    // Sleeve on seat tube with extension for top tube socket
    // Extension points in -tt_unit direction (toward head tube)
    // Need to account for seat tube angle

    difference() {
        union() {
            // Main sleeve around seat tube
            cylinder(h = stmj_height, d = seat_tube_od + 2*stmj_wall);

            // Extension for top tube socket
            // At mid-height of sleeve, extending in -tt_unit direction (rotated for seat tube angle)
            translate([0, 0, stmj_height/2])
                rotate([0, 90 + stmj_socket_rotation_y, 0])
                    rotate([stmj_socket_rotation_x, 0, 0]) {
                        cylinder(h = extension_depth, d = top_tube_od + 2*extension_thickness);

                        // Sphere for bolt hole material
                        translate([0, 0, extension_depth - extension_socket_depth + junction_socket_depth/2])
                            sphere(r = 8);
                    }
        }

        // Seat tube bore (passthrough for clamping)
        translate([0, 0, -epsilon])
            cylinder(h = stmj_height + 2*epsilon, d = seat_tube_od + socket_clearance);

        // Top tube socket bore
        translate([0, 0, stmj_height/2])
            rotate([0, 90 + stmj_socket_rotation_y, 0])
                rotate([stmj_socket_rotation_x, 0, 0])
                    translate([0, 0, extension_depth - extension_socket_depth])
                        cylinder(h = extension_socket_depth + epsilon, d = top_tube_od + socket_clearance);

        // Top tube bolt hole (M6 through-bolt)
        translate([0, 0, stmj_height/2])
            rotate([0, 90 + stmj_socket_rotation_y, 0])
                rotate([stmj_socket_rotation_x, 0, 0])
                    translate([0, 0, extension_depth - extension_socket_depth + junction_socket_depth/2])
                        rotate([90, 0, 0]) {
                            // Tap hole from one side
                            tap_start = (top_tube_od + socket_clearance)/2 - 2;
                            translate([0, 0, tap_start])
                                cylinder(h = m6_thread_depth, d = m6_tap_drill);

                            // Clearance hole from opposite side
                            translate([0, 0, -(top_tube_od/2 + extension_thickness)])
                                cylinder(h = top_tube_od/2 + extension_thickness - tap_start, d = joint_bolt_diameter + 0.5);

                            // Counterbore for socket head
                            translate([0, 0, -(top_tube_od/2 + extension_thickness)])
                                cylinder(h = 2.5, d = 9.5);
                        }

        // Pinch slot for seat tube clamping
        translate([0, -1, -epsilon])
            cube([seat_tube_od/2 + 2*stmj_wall, 2, stmj_height + 2*epsilon]);

        // Pinch bolt hole (M6 through-bolt)
        translate([seat_tube_od/2 + stmj_wall/2, 0, stmj_height/2])
            rotate([90, 0, 0]) {
                // Tap hole on one side
                translate([0, 0, -seat_tube_od/2 - stmj_wall])
                    cylinder(h = m6_thread_depth, d = m6_tap_drill);

                // Clearance hole from opposite side
                translate([0, 0, seat_tube_od/2])
                    cylinder(h = 20, d = joint_bolt_diameter + 0.5);

                // Counterbore for socket head
                translate([0, 0, seat_tube_od/2])
                    cylinder(h = 7, d = m6_socket_head_diameter);
            }
    }
}

// Wrapper to reposition origin at top tube socket entrance
module seat_tube_mid_junction_repositioned() {
    // Move junction so top tube socket entrance is at origin
    // Reverse all the transformations that position the socket
    translate([0, 0, extension_depth - extension_socket_depth])
        rotate([180-stmj_socket_rotation_x, 0, 0])
            rotate([0, -(90 + stmj_socket_rotation_y), 0])
                translate([0, 0, -stmj_height/2])
                    seat_tube_mid_junction();
}

// Render for preview
seat_tube_mid_junction_repositioned();
