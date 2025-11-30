// BB Junction
// CNC milled aluminum for NestWorks C500
// Central frame junction at bottom bracket
// Receives: down tube, seat tube, left/right chainstays
// Integrates with BB shell

include <../geometry.scad>
include <../lib/collar.scad>
include <../lib/sleeve_primitives.scad>

// Junction dimensions
bb_wall = 6;                 // Wall thickness around BB shell
bb_bore_length = 130;        // Total pedal bore length (e-bike mid-drive clearance)

module bb_junction() {
    // Use collar configuration from geometry.scad
    dt_collar = Collar(DOWN_TUBE, bb_dt_collar_internal_rotation, bb_dt_collar_height);
    st_collar = Collar(SEAT_TUBE, bb_st_collar_internal_rotation, bb_st_collar_height);

    difference() {
        union() {
            // Central cylinder for BB shell
            rotate([90, 0, 0])
                cylinder(h = bb_bore_length, d = bb_shell_od + 2*bb_wall, center = true);

            // Down tube collar
            rotate(bb_dt_collar_rotation)
                sleeve_collar(dt_collar);

            // Seat tube collar
            rotate(bb_st_collar_rotation)
                sleeve_collar(st_collar);
        }

        // Down tube collar negative
        rotate(bb_dt_collar_rotation)
            sleeve_collar(dt_collar, render_negative = true);

        // Seat tube collar negative
        rotate(bb_st_collar_rotation)
            sleeve_collar(st_collar, render_negative = true);

        // BB shell bore (through center, lateral)
        rotate([90, 0, 0])
            cylinder(h = bb_bore_length * 2, d = bb_shell_od + 0.5, center = true);
    }
}

// Render for preview
bb_junction();
