// Dropout Junction
// CNC milled aluminum for NestWorks C500
// Connects chainstay and seat stay to dropout
// One required per side (left and right)

include <../../config.scad>

// Junction dimensions
dj_height = 70;              // Vertical height
dj_width = 40;               // Width (lateral)
dj_depth = 50;               // Depth (fore-aft)
tube_socket_depth = 30;      // How deep tubes insert

module dropout_junction() {
    difference() {
        // Main body
        hull() {
            // Lower front (chainstay entry)
            translate([dj_depth/2 - 10, 0, 15])
                rotate([90, 0, 0])
                    cylinder(h = dj_width, r = 15, center = true);

            // Upper rear (seat stay entry)
            translate([-dj_depth/2 + 15, 0, dj_height - 15])
                rotate([90, 0, 0])
                    cylinder(h = dj_width, r = 15, center = true);

            // Dropout mounting area
            translate([0, 0, 0])
                cube([dj_depth - 10, dj_width, 10], center = true);
        }

        // Chainstay socket - comes from BB direction
        // Use orient_to: chainstay goes from bb toward dropout
        orient_to(bb + [0, 0, 0], dropout + [0, 0, 0])
            translate([0, 0, chainstay_length - tube_socket_depth - epsilon])
                cylinder(h = tube_socket_depth + 2*epsilon, d = chainstay_od + socket_clearance);

        // Chainstay bolt holes
        orient_to(bb + [0, 0, 0], dropout + [0, 0, 0])
            translate([0, 0, chainstay_length - tube_socket_depth/2])
                for (i = [0:1])
                    rotate([0, 0, i * 180])
                        rotate([90, 0, 0])
                            cylinder(h = dj_width + 10, d = joint_bolt_diameter + 0.5, center = true);

        // Seat stay socket - comes from st_top direction
        // Use orient_to: seat stay goes from st_top toward dropout
        orient_to(st_top + [0, 0, 0], dropout + [0, 0, 0])
            translate([0, 0, seat_stay_length - tube_socket_depth - epsilon])
                cylinder(h = tube_socket_depth + 2*epsilon, d = seat_stay_od + socket_clearance);

        // Seat stay bolt holes
        orient_to(st_top + [0, 0, 0], dropout + [0, 0, 0])
            translate([0, 0, seat_stay_length - tube_socket_depth/2])
                for (i = [0:1])
                    rotate([0, 0, i * 180])
                        rotate([90, 0, 0])
                            cylinder(h = dj_width + 10, d = joint_bolt_diameter + 0.5, center = true);

        // Dropout mounting holes (to bolt dropout plate)
        for (x = [-10, 10]) {
            translate([x, 0, -dj_height/2 + 5])
                cylinder(h = 20, d = 5 + 0.5);  // M5
        }

        // Axle clearance slot
        translate([5, 0, -5])
            rotate([90, 0, 0])
                cylinder(h = dj_width + 2*epsilon, d = dropout_axle_diameter + 2, center = true);

        // Weight reduction
        translate([0, 0, dj_height/2])
            rotate([90, 0, 0])
                cylinder(h = dj_width - 10, d = 15, center = true);
    }
}

// Render for preview
dropout_junction();
