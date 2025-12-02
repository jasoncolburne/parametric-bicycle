include <scad/geometry.scad>

// From seat_tube_mid_junction.scad
socket_depth = tube_socket_depth(SEAT_TUBE);
extension_depth = tube_extension_depth(SEAT_TUBE);

// Current calculation in component
rotation_angle = acos(tt_unit * seat_tube_unit);

echo("=== STMJ Alignment Debug ===");
echo("Top tube unit vector (tt_unit):", tt_unit);
echo("Seat tube unit vector (seat_tube_unit):", seat_tube_unit);
echo("Actual seat tube unit (st_unit):", st_unit);
echo("Rotation angle (current calc):", rotation_angle);
echo("Dot product (tt_unit * seat_tube_unit):", tt_unit * seat_tube_unit);

// The collar rotation is applied to align the collar socket with top tube
collar_rotation = [rotation_angle, 0, 0];
echo("Collar rotation:", collar_rotation);

// The sleeve rotation transforms the entire junction
sleeve_rotation = [180, 0, -90];
echo("Sleeve rotation:", sleeve_rotation);

// Net rotation applied to sleeve
net_rotation = sleeve_rotation - collar_rotation;
echo("Net rotation (sleeve - collar):", net_rotation);

// What we want: sleeve aligned with seat tube direction
// Seat tube unit vector
echo("Expected sleeve alignment (seat_tube_unit):", seat_tube_unit);
echo("Expected sleeve alignment (st_unit):", st_unit);
