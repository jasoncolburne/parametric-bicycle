// Seat Tube Top Junction
// CNC milled aluminum for NestWorks C500
// Connects seat tube top to seat stays
// Also serves as seat collar mount

include <../../config.scad>

// Junction dimensions
stj_height = 50;             // Height of junction
tube_socket_depth = 30;      // How deep tubes insert

module seat_tube_junction() {
    difference() {
        union() {
            // Main body around seat tube
            cylinder(h = stj_height, d = seat_tube_od + 16);

            // Extensions for seat stay sockets
            // Seat stays go from st_top toward dropout
            for (side = [-1, 1]) {
                // Direction from st_top to dropout (in local frame, st_top is at origin)
                ss_dir = (dropout + [0, side * ss_spread, 0]) - (st_top + [0, side * ss_spread, 0]);
                ss_len = norm(ss_dir);

                // Seat tube direction (local Z)
                st_dir = st_top - bb;

                // Angle between seat stay and seat tube
                dot = ss_dir[0]*st_dir[0] + ss_dir[2]*st_dir[2];
                ss_angle = acos(dot / (ss_len * norm(st_dir)));

                translate([0, side * ss_spread, stj_height/2])
                    rotate([0, ss_angle, 0])
                        cylinder(h = 40, d = seat_stay_od + 10);
            }
        }

        // Seat tube bore (continues through for seatpost)
        translate([0, 0, -epsilon])
            cylinder(h = stj_height + 2*epsilon, d = seat_tube_od + socket_clearance);

        // Seat post bore (smaller, for seatpost)
        translate([0, 0, stj_height - 20])
            cylinder(h = 20 + epsilon, d = seat_tube_id);

        // Seat stay sockets - using orient_to for correct angles
        for (side = [-1, 1]) {
            // Position at st_top with offset, orient toward dropout
            orient_to(st_top + [0, side * ss_spread, 0], dropout + [0, side * ss_spread, 0])
                translate([0, 0, -tube_socket_depth - 10])
                    cylinder(h = tube_socket_depth + 50, d = seat_stay_od + socket_clearance);

            // Seat stay bolt holes
            orient_to(st_top + [0, side * ss_spread, 0], dropout + [0, side * ss_spread, 0])
                translate([0, 0, tube_socket_depth/2])
                    for (i = [0:1])
                        rotate([0, 0, i * 180])
                            rotate([90, 0, 0])
                                cylinder(h = seat_stay_od + 20, d = joint_bolt_diameter + 0.5, center = true);
        }

        // Seat collar pinch slot
        translate([seat_tube_od/2 + 5, -1, stj_height - 25])
            cube([10, 2, 25 + epsilon]);

        // Seat collar pinch bolt
        translate([seat_tube_od/2 + 8, 0, stj_height - 12])
            rotate([90, 0, 0])
                cylinder(h = seat_tube_od + 20, d = 5 + 0.5, center = true);
    }
}

// Render for preview
seat_tube_junction();
