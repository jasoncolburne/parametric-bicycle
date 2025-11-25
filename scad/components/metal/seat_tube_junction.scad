// Seat Tube Top Junction
// CNC milled aluminum for NestWorks C500
// Connects seat tube top to seat stays
// Also serves as seat collar mount

include <../../config.scad>

// Junction dimensions
stj_height = 60;             // Height of junction

module seat_tube_junction() {
    // This junction is placed with:
    //   orient_to(bb_seat_tube, st_top)
    //   translate([0, 0, norm(st_top - bb_seat_tube) - stj_height])
    //
    // So local Z points along seat tube toward st_top
    // Junction top (at local Z = stj_height) is at st_top

    // Seat stays connect at st_top + [0, ±ss_spread, st_seat_stay_z]
    // In local coords, st_top is at [0, 0, stj_height]
    // st_seat_stay_z is a world Z offset that needs to be projected

    // The junction is placed in assembly with:
    //   orient_to(bb_seat_tube, st_top)
    //   translate([0, 0, norm(st_top - bb_seat_tube) - stj_height])
    //
    // So junction local origin is at world position along seat tube,
    // stj_height below st_top (measured along tube axis).
    // Junction top (local Z = stj_height) is at st_top.

    // Seat stay connects at world position: st_top + [0, ±ss_spread, st_seat_stay_z]
    // In local coords, st_top is at [0, 0, stj_height]
    // We need to transform the world offset [0, 0, st_seat_stay_z] to local

    // The seat tube direction in world coords:
    _tube_len = norm(st_top - bb_seat_tube);
    _tube_dir = (st_top - bb_seat_tube) / _tube_len;

    // orient_to rotation angle around Y axis (same as used in assembly):
    _dx_tube = st_top[0] - bb_seat_tube[0];
    _dz_tube = st_top[2] - bb_seat_tube[2];
    _az = atan2(_dx_tube, _dz_tube);

    // Junction origin in world coords (same calculation as used for sockets)
    junction_origin = bb_seat_tube + _tube_dir * (_tube_len - stj_height);

    // Transform seat stay world position to local coords
    // Seat stay connects at: st_top + [0, ±ss_spread, st_seat_stay_z]
    ss_world_center = st_top + [0, 0, st_seat_stay_z];
    ss_offset = ss_world_center - junction_origin;

    // Apply inverse rotation (rotate by -_az around Y)
    ss_local_x = ss_offset[0] * cos(_az) - ss_offset[2] * sin(_az);
    ss_local_z = ss_offset[0] * sin(_az) + ss_offset[2] * cos(_az);

    // For dropout end points, we need the full direction
    // Seat stay goes from st_top + [0, ±ss_spread, st_seat_stay_z]
    //                  to dropout + [0, ±cs_spread, dropout_seat_stay_z]

    difference() {
        union() {
            // Hull the main collar with the seat stay lugs for integrated structure
            hull() {
                // Main body around seat tube (seat collar)
                cylinder(h = stj_height, d = seat_tube_od + 16);

                // Seat stay lugs
                for (side = [-1, 1]) {
                    translate([ss_local_x, side * ss_spread, ss_local_z])
                        sphere(r = seat_stay_od/2 + 8);
                }
            }

            // Collar cylinders to cap seat stay sockets
            // Use same coordinate transformation as sockets
            for (side = [-1, 1]) {
                ss_world_start = st_top + [0, side * ss_spread, st_seat_stay_z];
                ss_world_end = dropout + [0, side * ss_spread, dropout_seat_stay_z];

                ss_start_offset = ss_world_start - junction_origin;
                ss_local_start = [
                    ss_start_offset[0] * cos(_az) - ss_start_offset[2] * sin(_az),
                    ss_start_offset[1],
                    ss_start_offset[0] * sin(_az) + ss_start_offset[2] * cos(_az)
                ];

                ss_end_offset = ss_world_end - junction_origin;
                ss_local_end = [
                    ss_end_offset[0] * cos(_az) - ss_end_offset[2] * sin(_az),
                    ss_end_offset[1],
                    ss_end_offset[0] * sin(_az) + ss_end_offset[2] * cos(_az)
                ];

                // Cylinder along seat stay axis extending toward dropout
                // Provides socket material so tube doesn't need to penetrate deep into junction
                orient_to(ss_local_start, ss_local_end)
                    cylinder(h = junction_socket_depth + 10, d = seat_stay_od + 16);
            }

            // Pinch bolt sleeve - connects the two counterbore surfaces
            translate([seat_tube_od/2 + 4, 0, stj_height - 12])
                rotate([90, 0, 0])
                    cylinder(h = seat_tube_od + 16, d = 10, center = true);
        }

        // Seat tube bore (for seat tube insertion from bottom)
        // Extends from bottom to below seat post bore
        translate([0, 0, -10])
            cylinder(h = 45, d = seat_tube_od + socket_clearance);

        // Seat tube bolt holes (match tube orientation and position)
        // Position on left/right sides, oriented front-to-back
        translate([0, 0, 22.5])
            for (side = [-1, 1])
                translate([0, side * ((seat_tube_od + socket_clearance)/2 + 3), 0])
                    rotate([90, 0, 0])
                        cylinder(h = 50, d = joint_bolt_diameter + 0.5, center = true);

        // Seat post bore (smaller, for seatpost at top)
        // Starts where seat tube ends and extends upward through hull
        translate([0, 0, 35])
            cylinder(h = stj_height - 35 + 10, d = seat_tube_id);

        // Seat stay sockets
        for (side = [-1, 1]) {
            // World positions of seat stay endpoints
            ss_world_start = st_top + [0, side * ss_spread, st_seat_stay_z];
            ss_world_end = dropout + [0, side * ss_spread, dropout_seat_stay_z];

            // Transform both endpoints to local coordinates using _az and junction_origin from above
            // Transform ss_world_start to local
            ss_start_offset = ss_world_start - junction_origin;
            ss_local_start = [
                ss_start_offset[0] * cos(_az) - ss_start_offset[2] * sin(_az),
                ss_start_offset[1],
                ss_start_offset[0] * sin(_az) + ss_start_offset[2] * cos(_az)
            ];

            // Transform ss_world_end to local
            ss_end_offset = ss_world_end - junction_origin;
            ss_local_end = [
                ss_end_offset[0] * cos(_az) - ss_end_offset[2] * sin(_az),
                ss_end_offset[1],
                ss_end_offset[0] * sin(_az) + ss_end_offset[2] * cos(_az)
            ];

            // Socket in collar - tube enters from dropout end
            // Standard depth: starts at Z=5, extends junction_socket_depth (25mm to Z=30)
            orient_to(ss_local_start, ss_local_end)
                translate([0, 0, 5])
                    cylinder(h = junction_socket_depth, d = seat_stay_od + socket_clearance);

            // Bolt holes in collar section
            // Position holes at [0, 180] to match tube holes
            // Socket starts at Z=5, extends to Z=30 (5 + 25 standard depth)
            // Tube starts at ss_local_start with -5mm offset, so tube Z=0 at ss_local_start
            // Tube bolt at 12.5mm from tube start = Z=12.5 relative to ss_local_start = Z=7.5 in junction coords
            // So junction bolt should be at Z=7.5 to align
            orient_to(ss_local_start, ss_local_end)
                translate([0, 0, 7.5])
                    for (angle = [0, 180])
                        rotate([0, 0, angle])
                            rotate([90, 0, 0])
                                translate([0, 0, -seat_stay_od/2 - 8])
                                    cylinder(h = seat_stay_od + 16, d = joint_bolt_diameter + 0.5);
        }

        // Seat collar pinch slot - cuts through body but not all the way in Y
        // Leave material on front and back for bolt to clamp
        translate([0, -1, stj_height - 25])
            cube([seat_tube_od/2 + 16, 2, 26]);

        // Seat collar pinch bolt hole
        translate([seat_tube_od/2 + 4, 0, stj_height - 12])
            rotate([90, 0, 0])
                cylinder(h = seat_tube_od + 16, d = 5.5, center = true);

        // Counterbore for bolt head (front) - extends past body edge
        translate([seat_tube_od/2 + 4, seat_tube_od/2 + 10, stj_height - 12])
            rotate([90, 0, 0])
                cylinder(h = 15, d = 10);

        // Counterbore for nut (back) - extends past body edge
        translate([seat_tube_od/2 + 4, -seat_tube_od/2 - 10, stj_height - 12])
            rotate([-90, 0, 0])
                cylinder(h = 15, d = 10);
    }
}

// Render for preview
seat_tube_junction();
