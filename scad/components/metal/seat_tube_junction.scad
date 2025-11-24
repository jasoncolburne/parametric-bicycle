// Seat Tube Top Junction
// CNC milled aluminum for NestWorks C500
// Connects seat tube top to seat stays
// Also serves as seat collar mount

include <../../config.scad>

// Junction dimensions
stj_height = 60;             // Height of junction
socket_depth = 25;           // How deep tubes insert

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

    // orient_to rotation angle around Y axis:
    _st_az = atan2(_tube_dir[0], _tube_dir[2]);

    // To transform world offset [0, 0, st_seat_stay_z] to local coords,
    // we need to think about what this offset means geometrically.
    //
    // st_seat_stay_z = -15 means 15mm below st_top in world Z
    // In local coords (junction oriented along seat tube):
    // - Going down in world Z means going "backward" along seat tube (negative local Z)
    // - But also going "forward" in world X due to seat tube lean
    //
    // The local Z component is the projection onto tube axis:
    //   local_z_offset = st_seat_stay_z * cos(90 - seat_tube_angle) = st_seat_stay_z * sin(seat_tube_angle)
    // The local X component is the perpendicular:
    //   local_x_offset = st_seat_stay_z * sin(90 - seat_tube_angle) = st_seat_stay_z * cos(seat_tube_angle)
    //
    // With seat_tube_angle = 72°, st_seat_stay_z = -15:
    //   local_z_offset = -15 * sin(72°) ≈ -14.3
    //   local_x_offset = -15 * cos(72°) ≈ -4.6
    //
    // Wait, that gives negative local X. Let me reconsider.
    // Actually the issue is the direction of the perpendicular.
    // When world Z decreases, local Z decreases AND local X increases (forward).
    // So local_x = -st_seat_stay_z * cos(seat_tube_angle)

    ss_local_x = -st_seat_stay_z * cos(seat_tube_angle);
    ss_local_z = stj_height + st_seat_stay_z * sin(seat_tube_angle);

    // For dropout end points, we need the full direction
    // Seat stay goes from st_top + [0, ±ss_spread, st_seat_stay_z]
    //                  to dropout + [0, ±cs_spread, dropout_seat_stay_z]

    difference() {
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

        // Seat tube bore (continues through entire junction for seat tube insertion)
        // Extended to clear through hulled body
        translate([0, 0, -10])
            cylinder(h = stj_height + 20, d = seat_tube_od + socket_clearance);

        // Seat post bore (smaller, for seatpost at top)
        translate([0, 0, stj_height - 20])
            cylinder(h = 21, d = seat_tube_id);

        // Seat stay sockets
        for (side = [-1, 1]) {
            // World positions of seat stay endpoints
            ss_world_start = st_top + [0, side * ss_spread, st_seat_stay_z];
            ss_world_end = dropout + [0, side * ss_spread, dropout_seat_stay_z];

            // Junction origin in world coords
            // Junction is placed at: orient_to(bb_seat_tube, st_top) translate([0,0,norm-stj_height])
            // So junction origin (local [0,0,0]) is at world position along seat tube axis
            _tube_len = norm(st_top - bb_seat_tube);
            _tube_dir = (st_top - bb_seat_tube) / _tube_len;
            junction_origin = bb_seat_tube + _tube_dir * (_tube_len - stj_height);

            // Transform both endpoints to local coordinates
            // First translate to junction origin, then apply inverse rotation
            _dx_tube = st_top[0] - bb_seat_tube[0];
            _dz_tube = st_top[2] - bb_seat_tube[2];
            _az = atan2(_dx_tube, _dz_tube);

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

            // Socket at ss_local_start, pointing toward ss_local_end (dropout)
            // Extended to go completely through the lug
            orient_to(ss_local_start, ss_local_end)
                translate([0, 0, -socket_depth - 50])
                    cylinder(h = socket_depth + 100, d = seat_stay_od + socket_clearance);

            // Bolt holes at socket midpoint
            // Single hole through both sides, offset away from junction center
            orient_to(ss_local_start, ss_local_end)
                translate([0, 0, -socket_depth/2])
                    rotate([90, 0, 0])
                        translate([0, 0, -seat_stay_od/2 - 8])
                            cylinder(h = seat_stay_od + 16, d = joint_bolt_diameter + 0.5);
        }

        // Seat collar pinch slot
        translate([seat_tube_od/2 + 5, -1, stj_height - 25])
            cube([10, 2, 26]);

        // Seat collar pinch bolt
        translate([seat_tube_od/2 + 8, 0, stj_height - 12])
            rotate([90, 0, 0])
                cylinder(h = seat_tube_od + 20, d = 5.5, center = true);
    }
}

// Render for preview
seat_tube_junction();
