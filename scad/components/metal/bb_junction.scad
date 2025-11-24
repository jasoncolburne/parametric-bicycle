// BB Junction
// CNC milled aluminum for NestWorks C500
// Central frame junction at bottom bracket
// Receives: down tube, seat tube, left/right chainstays
// Integrates with BB shell

include <../../config.scad>

// Junction dimensions
bb_junc_width = 160;         // Width (lateral) - accommodates chainstay spread
bb_junc_height = 120;        // Height (vertical)
bb_junc_depth = 100;         // Depth (fore-aft)
socket_depth = 25;           // How deep tubes insert

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
        // Main body - rounded block centered on BB
        hull() {
            for (x = [-bb_junc_depth/2 + 15, bb_junc_depth/2 - 15]) {
                for (y = [-bb_junc_width/2 + 15, bb_junc_width/2 - 15]) {
                    translate([x, y, -bb_junc_height/2 + 15])
                        sphere(r = 15);
                    translate([x, y, bb_junc_height/2 - 15])
                        sphere(r = 15);
                }
            }
        }

        // BB shell bore (through center, lateral)
        rotate([90, 0, 0])
            cylinder(h = bb_junc_width + 10, d = bb_shell_od + 0.5, center = true);

        // Down tube socket - at dt_end, pointing toward dt_start
        // Socket extends both inward and outward from connection point
        orient_to(dt_end, dt_start)
            translate([0, 0, -socket_depth])
                cylinder(h = socket_depth * 2, d = down_tube_od + socket_clearance);

        // Down tube bolt holes
        orient_to(dt_end, dt_start)
            translate([0, 0, -socket_depth/2])
                for (angle = [0, 180])
                    rotate([0, 0, angle])
                        rotate([90, 0, 0])
                            cylinder(h = 60, d = joint_bolt_diameter + 0.5, center = true);

        // Seat tube socket - at st_end, pointing toward st_start
        orient_to(st_end, st_start)
            translate([0, 0, -socket_depth])
                cylinder(h = socket_depth * 2, d = seat_tube_od + socket_clearance);

        // Seat tube bolt holes
        orient_to(st_end, st_start)
            translate([0, 0, -socket_depth/2])
                for (angle = [0, 180])
                    rotate([0, 0, angle])
                        rotate([90, 0, 0])
                            cylinder(h = 60, d = joint_bolt_diameter + 0.5, center = true);

        // Chainstay sockets - both sides
        for (side = [-1, 1]) {
            cs_end = [0, side * cs_spread, bb_chainstay_z];
            cs_start = dropout + [0, side * cs_spread, dropout_chainstay_z];

            // Socket - at cs_end, pointing toward cs_start
            orient_to(cs_end, cs_start)
                translate([0, 0, -socket_depth])
                    cylinder(h = socket_depth * 2, d = chainstay_od + socket_clearance);

            // Bolt holes
            orient_to(cs_end, cs_start)
                translate([0, 0, -socket_depth/2])
                    for (angle = [0, 180])
                        rotate([0, 0, angle])
                            rotate([90, 0, 0])
                                cylinder(h = 50, d = joint_bolt_diameter + 0.5, center = true);
        }
    }
}

// Render for preview
bb_junction();
