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
            // First create the hulled main body without the collar cylinders
            difference() {
                hull() {
                    // Main body around seat tube (seat collar)
                    cylinder(h = stj_height, d = seat_tube_od + 16);

                    // Seat stay lugs
                    for (side = [-1, 1]) {
                        translate([ss_local_x, side * ss_spread, ss_local_z])
                            sphere(r = seat_stay_od/2 + 10);
                    }
                }

                // Subtract collar cylinders from hull to make room for socketed collars
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

                    // Subtract same volume as collar sleeve (35mm)
                    orient_to(ss_local_start, ss_local_end)
                        translate([0, 0, 5])
                            cylinder(h = 35, d = seat_stay_od + 16);
                }
            }

            // Now add back collar cylinders with sockets pre-cut
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

                // Collar with socket passing through entire length
                difference() {
                    // Collar sleeve - 35mm tall starting at Z=5
                    orient_to(ss_local_start, ss_local_end)
                        translate([0, 0, 5])
                            cylinder(h = 35, d = seat_stay_od + 16);

                    // Socket hole - starts before sleeve and extends beyond to ensure complete penetration
                    orient_to(ss_local_start, ss_local_end)
                        translate([0, 0, 4])
                            cylinder(h = 37, d = seat_stay_od + socket_clearance);
                }
            }

            // Pinch bolt sleeve - reinforcement around pinch bolt hole
            // Capped on back side (negative Y), open on front side for bolt access
            translate([seat_tube_od/2 + 4, 0, stj_height - 12])
                rotate([90, 0, 0]) {
                    // Sleeve tube
                    cylinder(h = seat_tube_od + 16, d = 10, center = true);

                    // Hemispherical cap on back end (negative Y side)
                    translate([0, 0, (seat_tube_od + 16)/2])
                        sphere(d = 10);
                }
        }

        // Seat tube bore (for seat tube insertion from bottom)
        // Extends from bottom to below seat post bore
        translate([0, 0, -10])
            cylinder(h = 45, d = seat_tube_od + socket_clearance);

        // Seat tube bolt hole with counterbore and threaded mounting
        // Design: M6 socket head cap screw inserts from front (positive Y)
        //   - Front: Deeper counterbore (10mm) for 10mm socket head
        //   - Middle: 6.5mm clearance hole for M6 bolt shaft
        //   - Back: 12mm threaded hole (5.0mm tap drill)
        // Bolt is 3mm from inner bore edge, measure from there
        translate([0, 0, 22.5])
            translate([0, (seat_tube_od + socket_clearance)/2 + 3, 0])
                rotate([90, 0, 0]) {
                    // Deeper counterbore for socket head cap screw (outside)
                    translate([0, 0, -25])
                        cylinder(h = 12, d = m6_socket_head_diameter);

                    // Clearance hole for bolt shaft (from counterbore end through cavity)
                    // Needs to reach through cavity to opposite side
                    translate([0, 0, -13])
                        cylinder(h = 30,
                                 d = joint_bolt_diameter + 0.5);
                }

        // Tap hole from opposite side (starts 5mm inside cavity, drills outward)
        translate([0, 0, 22.5])
            translate([0, -((seat_tube_od + socket_clearance)/2 + 3 - 5), 0])
                rotate([90, 0, 0])
                    cylinder(h = m6_thread_depth + 5, d = m6_tap_drill);

        // Seat post bore (smaller, for seatpost at top)
        // Starts where seat tube ends and extends upward through hull
        translate([0, 0, 35])
            cylinder(h = stj_height - 35 + 10, d = seat_tube_id);

        // Seat stay bolt holes with counterbores and threaded mounting
        // Design: M6 socket head cap screws insert from outside
        //   - Outer: 7mm counterbore for 10mm socket head (6mm height + 1mm clearance)
        //   - Middle: 6.5mm clearance hole for M6 bolt shaft
        //   - Inner: 12mm threaded hole (5.0mm tap drill for M6 x 1.0 threads)
        // Assembly: Socket head screws install from outside, thread into aluminum (no nuts needed)
        // Position: Z=17.5mm (centered in 35mm collar spanning Z=5 to Z=40)
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

            orient_to(ss_local_start, ss_local_end)
                translate([0, 0, 17.5])
                    rotate([side * 90, 0, 0]) {
                        // Counterbore for socket head cap screw (outer side, shallower for more clamping)
                        translate([0, 0, -seat_stay_od/2 - 8])
                            cylinder(h = 5, d = m6_socket_head_diameter);

                        // Clearance hole for bolt shaft (from counterbore end, short)
                        translate([0, 0, -seat_stay_od/2 - 8 + 5])
                            cylinder(h = 5,
                                     d = joint_bolt_diameter + 0.5);
                    }

            // Tap hole from opposite side (starts inside cavity, drills outward)
            orient_to(ss_local_start, ss_local_end)
                translate([0, 0, 17.5])
                    rotate([side * 90, 0, 0])
                        translate([0, 0, seat_stay_od/2 - 2])
                            cylinder(h = m6_thread_depth, d = m6_tap_drill);
        }

        // Seat collar pinch slot - cuts through body but not all the way in Y
        // Leave material on front and back for bolt to clamp
        translate([0, -1, stj_height - 25])
            cube([seat_tube_od/2 + 16, 2, 30]);

        // Seat collar pinch bolt hole with counterbore and threaded mounting
        // Design: M6 socket head cap screw inserts from front (positive Y)
        //   - Front: Extended counterbore to clear hull material (starts further out)
        //   - Middle: 6.5mm clearance hole for M6 bolt shaft
        //   - Back: 12mm threaded hole (5.0mm tap drill for M6 x 1.0 threads)
        translate([seat_tube_od/2 + 4, 0, stj_height - 12])
            rotate([90, 0, 0]) {
                // Total length calculation: seat_tube_od + 16 = ~48mm
                // Extended counterbore for socket head cap screw (front side, positive Y)
                // Starts 8mm further out, extends 15mm total to clear hull
                translate([0, 0, -(seat_tube_od + 16)/2 - 8])
                    cylinder(h = 15, d = m6_socket_head_diameter);

                // Clearance hole for bolt shaft (reaches to centerline Y=0)
                // Starts where counterbore ends, extends to global Y=0
                translate([0, 0, -(seat_tube_od + 16)/2 - 8 + 15])
                    cylinder(h = (seat_tube_od + 16)/2 + 8 - 15,
                             d = joint_bolt_diameter + 0.5);

                // Tap drill hole for M6 threads (from centerline through slot into material)
                // Slot is 2mm wide (Y=-1 to Y=+1), so start at -1 to reach material at +1
                translate([0, 0, -1])
                    cylinder(h = m6_thread_depth + 1, d = m6_tap_drill);
            }
    }
}

// Render for preview
seat_tube_junction();
