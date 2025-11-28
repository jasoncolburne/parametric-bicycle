// Seat Tube Mid Junction
// CNC milled aluminum for NestWorks C500
// Connects top tube to seat tube at calculated position
// Sleeve clamps onto seat tube with through bolt

include <../../config.scad>

// Junction dimensions
stmj_height = 50;            // Height of junction sleeve on seat tube
stmj_wall = 6;               // Wall thickness around seat tube

module seat_tube_mid_junction() {
    // Sleeve on seat tube with extension for top tube socket
    // Extension points in -tt_unit direction (toward head tube)
    // Sleeve rotated to align with seat tube direction

    // Calculate seat tube direction and rotation from top tube direction
    st_vec = st_top - bb_seat_tube;
    st_unit = st_vec / norm(st_vec);
    rotation_angle = acos(tt_unit * st_unit);  // dot product

    difference() {
        union() {
            // extension
            translate([0, 0, -extension_socket_depth])
                cylinder(h=extension_depth, d = top_tube_od + 2 * extension_thickness);

            // sleeve on seat tube
            translate([0, 0, extension_depth-extension_socket_depth])
                rotate([0, rotation_angle, 0])
                    cylinder(h=stmj_height, d=seat_tube_od + 2*stmj_wall, center=true);
        }

        // extension bore
        translate([0, 0, -extension_socket_depth])
            cylinder(h=extension_socket_depth, d = top_tube_od + socket_clearance);

        // sleeve bore (seat tube passthrough)
        translate([0, 0, extension_depth-extension_socket_depth])
            rotate([0, rotation_angle, 0])
                translate([0, 0, -50])
                    cylinder(h=stmj_height*4, d=seat_tube_od + socket_clearance);
    }
}

// Render for preview
seat_tube_mid_junction();
