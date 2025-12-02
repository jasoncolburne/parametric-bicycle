// Seat Tube Mid Junction
// CNC milled aluminum for NestWorks C500
// Connects top tube to seat tube at calculated position
// Sleeve clamps onto seat tube with through bolt

include <../geometry.scad>
include <../lib/sleeve_primitives.scad>
include <../lib/collar.scad>

// Junction dimensions
stmj_height = 70;            // Height of junction sleeve on seat tube

module seat_tube_mid_junction(debug_color = "invisible", body_color = "silver", alpha = 1.0) {
    // Collar points backward along top tube (toward head tube, in -tt_unit direction)
    // Component is oriented along seat tube, so rotate from seat_tube_unit to -tt_unit
    // Compensate for the 90° Z rotation applied to align through holes
    rotation_angle = acos(seat_tube_unit * -tt_unit);
    collar_rotation = [0, rotation_angle, -90];

    // Top tube collar - points in -tt_unit direction (no rotation needed - default is up)
    collars = [
        Collar(TOP_TUBE, collar_rotation, stmj_height / 2, axis_rotation = 90)
    ];

    // Sleeve bolt position (middle of socket)
    tap_unit = stmj_height / 3;

    rotate([0, 0, 90])
        translate([0, 0, - stmj_height / 2])
            // Tapped sleeve with top tube collar
            tapped_sleeve(SEAT_TUBE, stmj_height, [tap_unit, tap_unit * 2], collars, debug_color, body_color, alpha);
}

// Render for preview
seat_tube_mid_junction();
