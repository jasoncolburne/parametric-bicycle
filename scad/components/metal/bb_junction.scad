// BB Junction
// CNC milled aluminum for NestWorks C500
// Central frame junction at bottom bracket
// Receives: down tube, seat tube, left/right chainstays
// Integrates with BB shell

include <../../config.scad>

// Junction dimensions
bb_wall = 6;                 // Wall thickness around BB shell
bb_central_radius = 40;      // Radius of central reinforcement cylinder
bb_central_length = 90;      // Length of central reinforcement (along Y-axis)
bb_bore_length = 130;        // Total pedal bore length (e-bike mid-drive clearance)

module bb_junction() {
    // Calculate local coordinates for tube endpoints
    // BB junction is at origin [0, 0, 0]

    // Down tube: from ht_down_tube to bb_down_tube
    dt_end = bb_down_tube;
    dt_start = ht_down_tube;

    // Seat tube: from bb_seat_tube to st_top
    st_end = bb_seat_tube;  // This is where seat tube starts (at BB)
    st_start = st_top;      // Seat tube goes toward st_top

    // Chainstays: from [0, ±cs_spread, bb_chainstay_z] to dropout + [0, ±cs_spread, dropout_chainstay_z]
    // We handle both sides

    difference() {
        union() {
            // Long thin cylinder for BB shell - minimal wall thickness
            hull() {
                rotate([90, 0, 0])
                    cylinder(h = bb_bore_length, d = bb_shell_od + 2*bb_wall, center = true);

                // Thicker central cylinder for structural strength
                rotate([90, 0, 0])
                    cylinder(h = bb_central_length, d = bb_central_radius * 2, center = true);
                }
            
            // Extension cylinders for each tube socket
            // Each extension starts tangent to outer surface of BB shell cylinder
            bb_outer_radius = (bb_shell_od + 2*bb_wall) / 2;

            // Down tube extension
            dt_radius_from_y_axis = sqrt(dt_end[0]*dt_end[0] + dt_end[2]*dt_end[2]);
            dt_offset = dt_radius_from_y_axis - bb_outer_radius;
            orient_to(dt_end, dt_start) {
                translate([0, 0, -dt_offset])
                    cylinder(h = extension_depth + dt_offset, d = down_tube_od + 2*extension_thickness);

                // Spherical boss for bolt hole (tap side only)
                translate([0, 0, extension_depth - extension_socket_depth + junction_socket_depth/2])
                    rotate([90, 0, 0])
                        translate([0, 0, (down_tube_od + 2*extension_thickness)/2])
                            sphere(r = 8);
            }

            // Seat tube extension
            st_radius_from_y_axis = sqrt(st_end[0]*st_end[0] + st_end[2]*st_end[2]);
            st_offset = st_radius_from_y_axis - bb_outer_radius;
            orient_to(st_end, st_start) {
                translate([0, 0, -st_offset])
                    cylinder(h = extension_depth + st_offset, d = seat_tube_od + 2*extension_thickness);

                // Spherical boss for bolt hole (tap side only)
                translate([0, 0, extension_depth - extension_socket_depth + junction_socket_depth/2])
                    rotate([90, 0, 0])
                        translate([0, 0, (seat_tube_od + 2*extension_thickness)/2])
                            sphere(r = 8);
            }

            // Chainstay extensions (both sides)
            for (side = [-1, 1]) {
                cs_end = [0, side * cs_spread, bb_chainstay_z];
                cs_start = dropout + [0, side * cs_spread, dropout_chainstay_z];
                cs_radius_from_y_axis = sqrt(cs_end[0]*cs_end[0] + cs_end[2]*cs_end[2]);
                cs_offset = cs_radius_from_y_axis - bb_outer_radius;

                orient_to(cs_end, cs_start) {
                    translate([0, 0, -cs_offset]) {
                        sphere(d=chainstay_od + 2*extension_thickness);
                        cylinder(h = extension_depth + cs_offset, d = chainstay_od + 2*extension_thickness);
                    }

                    // Spherical boss for bolt hole (smaller for chainstays)
                    // Rotate one side so both have counterbores on outside
                    translate([0, 0, extension_depth - junction_socket_depth + junction_socket_depth/2])
                        rotate([0, 0, side == 1 ? 0 : 180])  // Flip one side
                            rotate([90, 0, 0])
                                translate([0, 0, (chainstay_od + 2*extension_thickness)/2])
                                    sphere(r = 6);
                }
            }
        }

        // BB shell bore (through center, lateral)
        rotate([90, 0, 0])
            cylinder(h = bb_bore_length *2, d = bb_shell_od + 0.5, center = true);

        // Down tube socket bore (only junction_socket_depth deep)
        orient_to(dt_end, dt_start)
            translate([0, 0, extension_depth - extension_socket_depth])
                cylinder(h = extension_socket_depth + epsilon, d = down_tube_od + socket_clearance);

        // Down tube bolt holes (M6 through-bolt)
        orient_to(dt_end, dt_start)
            translate([0, 0, extension_depth - extension_socket_depth + junction_socket_depth/2])
                rotate([90, 0, 0]) {
                    // Tap hole from one side
                    translate([0, 0, (down_tube_od + socket_clearance)/2 - 2])
                        cylinder(h = m6_thread_depth, d = m6_tap_drill);

                    // Clearance hole from opposite side
                    translate([0, 0, -(down_tube_od/2 + extension_thickness)])
                        cylinder(h = down_tube_od/2 + extension_thickness - ((down_tube_od + socket_clearance)/2 - 2), d = joint_bolt_diameter + 0.5);

                    // Counterbore for socket head
                    translate([0, 0, -(down_tube_od/2 + extension_thickness)])
                        cylinder(h = 2.5, d = 9.5);
                }

        // Seat tube socket bore
        orient_to(st_end, st_start)
            translate([0, 0, extension_depth - extension_socket_depth])
                cylinder(h = extension_socket_depth + epsilon, d = seat_tube_od + socket_clearance);

        // Seat tube bolt holes (M6 through-bolt)
        orient_to(st_end, st_start)
            translate([0, 0, extension_depth - extension_socket_depth + junction_socket_depth/2])
                rotate([90, 0, 0]) {
                    // Tap hole from one side
                    translate([0, 0, (seat_tube_od + socket_clearance)/2 - 2])
                        cylinder(h = m6_thread_depth, d = m6_tap_drill);

                    // Clearance hole from opposite side
                    translate([0, 0, -(seat_tube_od/2 + extension_thickness)])
                        cylinder(h = seat_tube_od/2 + extension_thickness - ((seat_tube_od + socket_clearance)/2 - 2), d = joint_bolt_diameter + 0.5);

                    // Counterbore for socket head
                    translate([0, 0, -(seat_tube_od/2 + extension_thickness)])
                        cylinder(h = 2.5, d = 9.5);
                }

        // Chainstay sockets - both sides
        for (side = [-1, 1]) {
            cs_end = [0, side * cs_spread, bb_chainstay_z];
            cs_start = dropout + [0, side * cs_spread, dropout_chainstay_z];

            // Socket bore
            orient_to(cs_end, cs_start)
                translate([0, 0, extension_depth - junction_socket_depth])
                    cylinder(h = junction_socket_depth + epsilon, d = chainstay_od + socket_clearance);

            // Bolt holes (M5 through-bolt, smaller for chainstays)
            // Rotate one side so both have counterbores on outside
            m5_tap_drill = 4.2;
            m5_clearance = 5.5;
            m5_head_dia = 8.5;
            m5_thread_depth = 10;

            orient_to(cs_end, cs_start)
                translate([0, 0, extension_depth - junction_socket_depth + junction_socket_depth/2])
                    rotate([0, 0, side == 1 ? 0 : 180])  // Flip one side
                        rotate([90, 0, 0]) {
                            // Tap hole from one side
                            translate([0, 0, (chainstay_od + socket_clearance)/2 - 2])
                                cylinder(h = m5_thread_depth, d = m5_tap_drill);

                            // Clearance hole from opposite side
                            translate([0, 0, -(chainstay_od/2 + extension_thickness)])
                                cylinder(h = chainstay_od/2 + extension_thickness - ((chainstay_od + socket_clearance)/2 - 2), d = m5_clearance);

                            // Counterbore for socket head (on outside)
                            translate([0, 0, -(chainstay_od/2 + extension_thickness)])
                                cylinder(h = 2.5, d = m5_head_dia);
                        }
        }
    }
}

// Render for preview
bb_junction();
