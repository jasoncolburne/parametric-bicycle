include <scad/geometry.scad>

echo("=== Verify Top Tube Angle ===");
echo("");

// The tt_angle from geometry.scad is calculated from target vectors
echo("tt_angle (from targets):", tt_angle);
echo("");

// Recalculate the actual vectors from socket positions
actual_ht_vec = ht_top_tube - ht_down_tube;
actual_tt_vec = st_top_tube - ht_top_tube;

// Angle between head tube and actual top tube
actual_ht_dot_tt = actual_ht_vec[0]*actual_tt_vec[0] + actual_ht_vec[1]*actual_tt_vec[1] + actual_ht_vec[2]*actual_tt_vec[2];
actual_tt_angle = acos(actual_ht_dot_tt / (norm(actual_ht_vec) * norm(actual_tt_vec)));
echo("Actual angle (from socket-to-socket vectors):", actual_tt_angle);
echo("");

echo("Difference:", actual_tt_angle - tt_angle, "degrees");
echo("Match?", abs(actual_tt_angle - tt_angle) < 0.01);
