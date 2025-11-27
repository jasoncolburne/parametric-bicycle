// Seat Tube Mid Junction
// CNC milled aluminum for NestWorks C500
// Connects top tube to seat tube at mid-height
// Clamps onto seat tube with passthrough bolt

include <../../config.scad>

// Junction dimensions
stmj_height = 40;            // Height of junction collar
top_tube_od = 44;            // Top tube outer diameter (same as down tube)

module seat_tube_mid_junction() {
    // This junction clamps onto the seat tube at 50% height
    // It has a socket for the top tube pointing toward the head tube lug

    // Calculate top tube direction in local coordinates
    // Junction is positioned at 50% up seat tube
    // We need to figure out where the top tube socket should point

    // For now, create a basic collar with a socket
    // We'll refine the angle after calculating geometry in config.scad

    difference() {
        union() {
            // Main collar around seat tube
            cylinder(h = stmj_height, d = seat_tube_od + 16);

            // Extension for top tube socket
            // Positioned at mid-height, extending horizontally toward head tube
            // For now use a simple horizontal extension - we'll adjust angle later
            translate([0, 0, stmj_height/2])
                rotate([0, 90, 0])
                    cylinder(h = 60, d = top_tube_od + 12);  // 6mm walls like downtube socket

            // Sphere for bolt hole material at top tube socket
            translate([60, 0, stmj_height/2])
                sphere(r = 8);
        }

        // Seat tube bore (passthrough)
        translate([0, 0, -epsilon])
            cylinder(h = stmj_height + 2*epsilon, d = seat_tube_od + socket_clearance);

        // Top tube socket bore
        translate([0, 0, stmj_height/2])
            rotate([0, 90, 0])
                translate([0, 0, 60 - junction_socket_depth])
                    cylinder(h = junction_socket_depth + epsilon, d = top_tube_od + socket_clearance);

        // Top tube bolt hole (M6 through-bolt)
        translate([60 - junction_socket_depth/2, 0, stmj_height/2])
            rotate([90, 0, 0]) {
                // Tap hole from one side
                translate([0, 0, (top_tube_od + socket_clearance)/2 - 2])
                    cylinder(h = m6_thread_depth, d = m6_tap_drill);

                // Clearance hole from opposite side
                translate([0, 0, -(top_tube_od/2 + 6)])
                    cylinder(h = top_tube_od/2 + 6 - ((top_tube_od + socket_clearance)/2 - 2), d = joint_bolt_diameter + 0.5);

                // Counterbore for socket head
                translate([0, 0, -(top_tube_od/2 + 6)])
                    cylinder(h = 2.5, d = 9.5);
            }

        // Pinch slot for seat tube clamping
        translate([0, -1, -epsilon])
            cube([seat_tube_od/2 + 16, 2, stmj_height + 2*epsilon]);

        // Pinch bolt hole
        translate([seat_tube_od/2 + 4, 0, stmj_height/2])
            rotate([90, 0, 0]) {
                // Tap hole on one side
                translate([0, 0, -seat_tube_od/2 - 8])
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

// Render for preview
seat_tube_mid_junction();
