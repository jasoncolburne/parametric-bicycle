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

            // spherical boss for extension bolt hole
            translate([0, 0, -junction_socket_depth/2])
                rotate([90, 0, 0])
                    translate([0, 0, (top_tube_od + 2 * extension_thickness)/2])
                        sphere(r = 8);

            // sleeve on seat tube
            translate([0, 0, extension_depth-extension_socket_depth])
                rotate([0, rotation_angle, 0]) {
                    cylinder(h=stmj_height, d=top_tube_od + 2 * extension_thickness, center=true);

                    // spherical boss for sleeve through bolt
                    rotate([90, 0, 0])
                        translate([0, 0, (top_tube_od + 2 * extension_thickness)/2])
                            sphere(r = 8);
                }
        }

        // extension bore
        translate([0, 0, -extension_socket_depth])
            cylinder(h=extension_socket_depth, d = top_tube_od + socket_clearance);

        // sleeve bore (seat tube passthrough)
        translate([0, 0, extension_depth-extension_socket_depth])
            rotate([0, rotation_angle, 0])
                translate([0, 0, -50])
                    cylinder(h=stmj_height*4, d=seat_tube_od + socket_clearance);

        // extension bolt hole (M6 through-bolt)
        translate([0, 0, -junction_socket_depth/2])
            rotate([90, 0, 0]) {
                // Tap hole from one side
                translate([0, 0, (top_tube_od + socket_clearance)/2 - 2])
                    cylinder(h = m6_thread_depth, d = m6_tap_drill);

                // Clearance hole from opposite side
                translate([0, 0, -(top_tube_od/2 + extension_thickness)])
                    cylinder(h = top_tube_od/2 + extension_thickness - ((top_tube_od + socket_clearance)/2 - 2), d = joint_bolt_diameter + 0.5);

                // Counterbore for socket head
                translate([0, 0, -(top_tube_od/2 + extension_thickness)])
                    cylinder(h = 2.5, d = 9.5);
            }

        // sleeve through bolt hole
        translate([0, 0, extension_depth-extension_socket_depth])
            rotate([0, rotation_angle, 0])
                rotate([90, 0, 0]) {
                    sleeve_diameter = top_tube_od + 2 * extension_thickness;

                    // Tap hole from one side
                    translate([0, 0, (seat_tube_od + socket_clearance)/2 - 2])
                        cylinder(h = m6_thread_depth, d = m6_tap_drill);

                    // Clearance hole from opposite side - goes all the way through
                    translate([0, 0, -(sleeve_diameter/2)])
                        cylinder(h = sleeve_diameter/2 + sleeve_diameter/2 - ((seat_tube_od + socket_clearance)/2 - 2), d = joint_bolt_diameter + 0.5);

                    // Counterbore for socket head
                    translate([0, 0, -(sleeve_diameter/2)])
                        cylinder(h = 3.0, d = 9.5);
                }
    }
}

// Render for preview
seat_tube_mid_junction();
