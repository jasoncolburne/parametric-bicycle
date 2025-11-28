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
            // extension
            translate([0, 0, -extension_socket_depth])
                cylinder(h=extension_depth, d = top_tube_od + 2 * extension_thickness);
        }
        
        // extension bore
        translate([0, 0, -extension_socket_depth])
            cylinder(h=extension_socket_depth, d = top_tube_od + socket_clearance);
    }
}

// Render for preview
seat_tube_mid_junction();
