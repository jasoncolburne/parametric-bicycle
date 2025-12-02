include <scad/geometry.scad>

echo("=== Down Tube at BB Analysis ===");
echo("");

// Current calculation
echo("Current bb_down_tube:", bb_down_tube);
echo("Calculated as: dt_socket_distance * [cos(down_tube_angle), 0, sin(down_tube_angle)]");
echo("  dt_socket_distance:", dt_socket_distance);
echo("  down_tube_angle:", down_tube_angle);
echo("  Result:", bb_down_tube);
echo("");

// What if we add bb_shell_od/2 like chainstays do?
dt_bb_offset_with_shell = dt_socket_distance + bb_shell_od/2;
bb_down_tube_corrected = [
    dt_bb_offset_with_shell * cos(down_tube_angle),
    0,
    dt_bb_offset_with_shell * sin(down_tube_angle)
];

echo("If we add bb_shell_od/2 (like chainstays):");
echo("  dt_bb_offset:", dt_bb_offset_with_shell);
echo("  bb_down_tube_corrected:", bb_down_tube_corrected);
echo("  Difference from current:", bb_down_tube_corrected - bb_down_tube);
echo("  Distance:", norm(bb_down_tube_corrected - bb_down_tube), "mm");
echo("");

// The down tube direction vector
dt_vec = bb_down_tube - ht_down_tube;
dt_unit_vec = dt_vec / norm(dt_vec);

echo("Distance along down tube direction:");
echo("  Current to corrected:", (bb_down_tube_corrected - bb_down_tube) * dt_unit_vec, "mm");
echo("  This should equal bb_shell_od/2:", bb_shell_od/2, "mm");
