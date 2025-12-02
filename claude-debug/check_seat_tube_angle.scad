include <scad/geometry.scad>

// Calculate actual seat tube vector
actual_st_vec = st_top - bb_seat_tube;
actual_st_unit = actual_st_vec / norm(actual_st_vec);

// Calculate actual angle from horizontal
// For a vector [x, y, z], angle from horizontal in XZ plane is atan2(z, -x)
actual_angle = atan2(actual_st_unit[2], -actual_st_unit[0]);

echo("Analytical seat_tube_angle:", seat_tube_angle);
echo("Analytical seat_tube_unit:", seat_tube_unit);
echo("Actual st_unit:", st_unit);
echo("Actual angle from horizontal:", actual_angle);
echo("Difference:", actual_angle - seat_tube_angle);
