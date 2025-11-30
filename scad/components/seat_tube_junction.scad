// Seat Tube Top Junction
// CNC milled aluminum for NestWorks C500
// Connects seat tube top to seat stays
// Also serves as seat collar mount

include <../geometry.scad>
include <../lib/sleeve_primitives.scad>

// Junction dimensions
stj_height = 60;             // Height of junction

module seat_tube_junction_core() {
    // Calculate coordinate transformation parameters
    _tube_len = norm(st_top - bb_seat_tube);
    _tube_dir = (st_top - bb_seat_tube) / _tube_len;
    _az = atan2(st_top[0] - bb_seat_tube[0], st_top[2] - bb_seat_tube[2]);
    junction_origin = bb_seat_tube + _tube_dir * (_tube_len - stj_height);

    // Calculate seat stay positions once
    ss_world_center = st_top + [0, 0, st_seat_stay_z];
    ss_local = world_to_local(ss_world_center, junction_origin, _az);
    ss_local_x = ss_local[0];
    ss_local_z = ss_local[2];

    // Calculate seat stay local positions for each side
    ss_left_start = world_to_local(st_top + [-ss_spread, 0, st_seat_stay_z], junction_origin, _az);
    ss_left_end = world_to_local(dropout + [-cs_spread, 0, dropout_seat_stay_z], junction_origin, _az);
    ss_right_start = world_to_local(st_top + [ss_spread, 0, st_seat_stay_z], junction_origin, _az);
    ss_right_end = world_to_local(dropout + [cs_spread, 0, dropout_seat_stay_z], junction_origin, _az);

    difference() {
        union() {
            pinched_sleeve(SEAT_POST, SEAT_TUBE, stj_height, 25, [], 1);
        }
    }
}

// Render for preview
module seat_tube_junction() {
    translate([0, 0, -35])
        rotate([0, 0, 90])
            seat_tube_junction_core();
}

seat_tube_junction();