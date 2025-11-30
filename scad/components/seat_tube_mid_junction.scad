// Seat Tube Mid Junction
// CNC milled aluminum for NestWorks C500
// Connects top tube to seat tube at calculated position
// Sleeve clamps onto seat tube with through bolt

include <../geometry.scad>
include <../lib/sleeve_primitives.scad>
include <../lib/collar.scad>

// Junction dimensions
stmj_height = 70;            // Height of junction sleeve on seat tube

module seat_tube_mid_junction(debug_color = "invisible", body_color = "silver") {
    // Sleeve on seat tube with extension for top tube socket
    // Extension points in -tt_unit direction (toward head tube)
    // Sleeve rotated to align with seat tube direction
    socket_depth = tube_socket_depth(SEAT_TUBE);
    extension_depth = tube_extension_depth(SEAT_TUBE);

    // Calculate seat tube direction and rotation from top tube direction
    st_vec = st_top - bb_seat_tube;
    st_unit = st_vec / norm(st_vec);
    rotation_angle = acos(tt_unit * st_unit);  // dot product

    // Calculate rotation to align sleeve with seat tube
    // Collar rotation points opposite to tt_unit (toward head tube)
    collar_rotation = [rotation_angle, 0, 0];
    sleeve_rotation = [180, 0, -90];

    // Top tube collar - points in -tt_unit direction (no rotation needed - default is up)
    collars = [
        Collar(TOP_TUBE, collar_rotation, stmj_height / 2)
    ];

    // Sleeve bolt position (middle of socket)
    tap_unit = stmj_height / 3;


    // Rotate entire junction to align with seat tube
    translate([0, 0, extension_depth - socket_depth])
        rotate(sleeve_rotation - collar_rotation)
            translate([0, 0, - stmj_height / 2])
                // Tapped sleeve with top tube collar
                tapped_sleeve(SEAT_TUBE, stmj_height, [tap_unit, tap_unit * 2], collars, debug_color, body_color);
}

// Render for preview
seat_tube_mid_junction();
