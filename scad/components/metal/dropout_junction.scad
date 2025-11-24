// Dropout Junction
// CNC milled aluminum for NestWorks C500
// Connects chainstay and seat stay to dropout
// One required per side (left and right)

include <../../config.scad>

// Junction dimensions
dj_width = 60;               // Width (lateral) - increased to accommodate ss_spread offset
dj_depth = 50;               // Depth (fore-aft)
socket_depth = 25;           // How deep tubes insert

module dropout_junction(side = 1) {
    // Calculate local coordinates for tube endpoints
    // Junction is placed at: dropout + [0, side * cs_spread, 0]

    // Chainstay: from [0, side*cs_spread, bb_chainstay_z] to dropout + [0, side*cs_spread, dropout_chainstay_z]
    // In local coords:
    cs_end = [0, 0, dropout_chainstay_z];
    cs_start = [0, side * cs_spread, bb_chainstay_z] - (dropout + [0, side * cs_spread, 0]);
    // cs_start = [-dropout_x, 0, bb_chainstay_z - dropout_z]

    // Seat stay: from st_top + [0, side*ss_spread, st_seat_stay_z] to dropout + [0, side*ss_spread, dropout_seat_stay_z]
    // Seat stay keeps at ss_spread (no convergence with chainstay for structural rigidity)
    // Junction is at dropout + [0, side * cs_spread, 0], so seat stay end is offset laterally
    ss_end = [0, side * (ss_spread - cs_spread), dropout_seat_stay_z];
    ss_start = (st_top + [0, side * ss_spread, st_seat_stay_z]) - (dropout + [0, side * cs_spread, 0]);
    // ss_start = [st_top_x - dropout_x, side*(ss_spread - cs_spread), st_top_z + st_seat_stay_z - dropout_z]

    difference() {
        // Main body - hull around spheres for organic shape
        hull() {
            // Chainstay entry lug
            translate(cs_end)
                sphere(r = chainstay_od/2 + 10);

            // Seat stay entry lug
            translate(ss_end)
                sphere(r = seat_stay_od/2 + 8);

            // Axle boss - sphere around axle position
            translate([0, 0, 0])
                sphere(r = dropout_axle_diameter/2 + 10);

            // Rear support - sphere behind chainstay to cover protrusion
            translate([-20, 0, dropout_chainstay_z])
                sphere(r = chainstay_od/2 + 8);

            // Rear support - sphere behind seat stay to cover protrusion
            translate([-20, side * (ss_spread - cs_spread), dropout_seat_stay_z])
                sphere(r = seat_stay_od/2 + 10);
        }

        // Chainstay socket - at cs_end, pointing toward cs_start
        // Extends inward by socket_depth, outward by 5mm to capture tube end
        orient_to(cs_end, cs_start)
            translate([0, 0, -socket_depth])
                cylinder(h = socket_depth + 5, d = chainstay_od + socket_clearance);

        // Chainstay bolt holes
        orient_to(cs_end, cs_start)
            translate([0, 0, -socket_depth/2])
                for (angle = [0, 180])
                    rotate([0, 0, angle])
                        rotate([90, 0, 0])
                            cylinder(h = 50, d = joint_bolt_diameter + 0.5, center = true);

        // Seat stay socket - at ss_end, pointing toward ss_start
        orient_to(ss_end, ss_start)
            translate([0, 0, -socket_depth])
                cylinder(h = socket_depth + 1, d = seat_stay_od + socket_clearance);

        // Seat stay bolt holes
        orient_to(ss_end, ss_start)
            translate([0, 0, -socket_depth/2])
                for (angle = [0, 180])
                    rotate([0, 0, angle])
                        rotate([90, 0, 0])
                            cylinder(h = 50, d = joint_bolt_diameter + 0.5, center = true);

        // Axle clearance
        translate([0, 0, 0])
            rotate([90, 0, 0])
                cylinder(h = dj_width + 10, d = dropout_axle_diameter + 2, center = true);
    }
}

// Render for preview
dropout_junction();
