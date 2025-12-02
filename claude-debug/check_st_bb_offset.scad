include <scad/geometry.scad>

echo("=== Seat Tube at BB Analysis ===");
echo("");

// Current calculation
echo("Current bb_seat_tube:", bb_seat_tube);
echo("Calculated as: st_socket_distance * [cos(180-angle), 0, sin(180-angle)]");
echo("  st_socket_distance:", st_socket_distance);
echo("  Result:", bb_seat_tube);
echo("");

// What if we add bb_shell_od/2 like chainstays do?
st_bb_offset_with_shell = st_socket_distance + bb_shell_od/2;
bb_seat_tube_corrected = [
    st_bb_offset_with_shell * cos(180-seat_tube_angle),
    0,
    st_bb_offset_with_shell * sin(180-seat_tube_angle)
];

echo("If we add bb_shell_od/2 (like chainstays):");
echo("  st_bb_offset:", st_bb_offset_with_shell);
echo("  bb_seat_tube_corrected:", bb_seat_tube_corrected);
echo("  Difference from current:", bb_seat_tube_corrected - bb_seat_tube);
echo("  Distance:", norm(bb_seat_tube_corrected - bb_seat_tube), "mm");
echo("");

// Distance along seat tube
echo("Distance along seat_tube_unit:");
echo("  Current to corrected:", (bb_seat_tube_corrected - bb_seat_tube) * seat_tube_unit, "mm");
echo("  This should equal bb_shell_od/2:", bb_shell_od/2, "mm");
echo("");

echo("=== Impact on st_top ===");
st_top_current = bb_seat_tube + (frame_size - st_socket_distance) * seat_tube_unit;
st_top_corrected = bb_seat_tube_corrected + (frame_size - st_bb_offset_with_shell) * seat_tube_unit;

echo("Current st_top:", st_top_current);
echo("Corrected st_top:", st_top_corrected);
echo("Difference:", norm(st_top_corrected - st_top_current), "mm");
