include <scad/geometry.scad>

echo("=== BB Shell Geometry ===");
echo("bb_shell_od:", bb_shell_od);
echo("bb_shell_od / 2:", bb_shell_od / 2);
echo("");

echo("=== Seat Tube Socket Position ===");
echo("bb_seat_tube:", bb_seat_tube);
echo("This is calculated from st_socket_distance and seat_tube_angle");
echo("");

echo("st_socket_distance:", st_socket_distance);
echo("seat_tube_angle:", seat_tube_angle);
echo("");

// Where the seat tube actually starts (at BB shell surface)
// Should be at distance bb_shell_od/2 from origin along seat tube direction
bb_shell_surface_on_seat_tube = (bb_shell_od / 2) * seat_tube_unit;

echo("=== Comparison ===");
echo("BB shell surface on seat tube:", bb_shell_surface_on_seat_tube);
echo("bb_seat_tube (socket entrance):", bb_seat_tube);
echo("Difference:", bb_seat_tube - bb_shell_surface_on_seat_tube);
echo("Distance:", norm(bb_seat_tube - bb_shell_surface_on_seat_tube), "mm");
echo("");

// This difference should equal st_socket_distance
// (the socket extends inward from the entrance)
echo("Does difference ≈ st_socket_distance?");
echo("  Difference:", norm(bb_seat_tube - bb_shell_surface_on_seat_tube));
echo("  st_socket_distance:", st_socket_distance);
