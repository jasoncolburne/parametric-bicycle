include <scad/geometry.scad>

echo("=== TT Unit Vector Error ===");
echo("");

// What direction is tt_unit?
echo("tt_unit (from geometry.scad):", tt_unit);
echo("");

// What direction SHOULD it be (from socket to socket)?
actual_vec = st_top_tube - ht_top_tube;
actual_unit = actual_vec / norm(actual_vec);
echo("Actual direction (st_top_tube - ht_top_tube):", actual_unit);
echo("");

echo("Are they the same?");
echo("  Difference:", tt_unit - actual_unit);
echo("  Magnitude:", norm(tt_unit - actual_unit));
echo("");

// The error compounds over the tube length
echo("Error over", top_tube_length, "mm:");
error_vec = top_tube_length * (tt_unit - actual_unit);
echo("  ", error_vec);
echo("  Magnitude:", norm(error_vec), "mm");
