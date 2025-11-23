// BB Junction
// CNC milled aluminum for NestWorks C500
// Central frame junction at bottom bracket
// Receives: down tube, seat tube, left/right chainstays
// Integrates with BB shell

include <../../config.scad>

// Import tube modules for boolean subtraction
use <../plastic-cf/down_tube.scad>
use <../plastic-cf/seat_tube.scad>
use <../plastic-cf/chainstay.scad>

// Junction dimensions
bb_junc_width = 100;         // Width (lateral)
bb_junc_height = 80;         // Height (vertical)
bb_junc_depth = 60;          // Depth (fore-aft)
tube_socket_depth = 30;      // How deep tubes insert

module bb_junction() {
    difference() {
        // Main body - rounded block
        hull() {
            for (x = [10, bb_junc_depth - 10]) {
                for (y = [10, bb_junc_width - 10]) {
                    translate([x - bb_junc_depth/2, y - bb_junc_width/2, 0])
                        cylinder(h = bb_junc_height, r = 10);
                }
            }
        }

        // BB shell bore (through center, lateral)
        translate([0, -bb_junc_width/2 - epsilon, bb_junc_height/2])
            rotate([-90, 0, 0])
                cylinder(h = bb_junc_width + 2*epsilon, d = bb_shell_od + 0.5);

        // --- TUBE SOCKETS (using actual tube geometry) ---

        // Down tube socket - positioned same as in assembly
        // Down tube goes from ht_bottom toward bb, so we position at bb end
        orient_to(ht_bottom, bb)
            translate([0, 0, down_tube_length - tube_socket_depth - epsilon])
                cylinder(h = tube_socket_depth + 2*epsilon, d = down_tube_od + socket_clearance);

        // Down tube bolt holes
        orient_to(ht_bottom, bb)
            translate([0, 0, down_tube_length - tube_socket_depth/2])
                for (i = [0:1])
                    rotate([0, 0, i * 180])
                        rotate([90, 0, 0])
                            cylinder(h = bb_junc_width, d = joint_bolt_diameter + 0.5, center = true);

        // Seat tube socket - goes from bb toward st_top
        orient_to(bb, st_top)
            translate([0, 0, -epsilon])
                cylinder(h = tube_socket_depth + epsilon, d = seat_tube_od + socket_clearance);

        // Seat tube bolt holes
        orient_to(bb, st_top)
            translate([0, 0, tube_socket_depth/2])
                for (i = [0:1])
                    rotate([0, 0, i * 180])
                        rotate([90, 0, 0])
                            cylinder(h = bb_junc_width, d = joint_bolt_diameter + 0.5, center = true);

        // Left chainstay socket
        orient_to(bb + [0, -cs_spread, 0], dropout + [0, -cs_spread, 0])
            translate([0, 0, -epsilon])
                cylinder(h = tube_socket_depth + epsilon, d = chainstay_od + 4 + socket_clearance);  // +4 for BB end taper

        // Left chainstay bolt holes
        orient_to(bb + [0, -cs_spread, 0], dropout + [0, -cs_spread, 0])
            translate([0, 0, tube_socket_depth/2])
                for (i = [0:1])
                    rotate([0, 0, i * 180])
                        rotate([90, 0, 0])
                            cylinder(h = bb_junc_depth, d = joint_bolt_diameter + 0.5, center = true);

        // Right chainstay socket
        orient_to(bb + [0, cs_spread, 0], dropout + [0, cs_spread, 0])
            translate([0, 0, -epsilon])
                cylinder(h = tube_socket_depth + epsilon, d = chainstay_od + 4 + socket_clearance);

        // Right chainstay bolt holes
        orient_to(bb + [0, cs_spread, 0], dropout + [0, cs_spread, 0])
            translate([0, 0, tube_socket_depth/2])
                for (i = [0:1])
                    rotate([0, 0, i * 180])
                        rotate([90, 0, 0])
                            cylinder(h = bb_junc_depth, d = joint_bolt_diameter + 0.5, center = true);

        // Weight reduction holes
        for (y = [-20, 20]) {
            translate([0, y, -epsilon])
                cylinder(h = bb_junc_height/3, d = 15);
        }
    }
}

// Render for preview
bb_junction();
