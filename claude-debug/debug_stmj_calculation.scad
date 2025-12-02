include <scad/geometry.scad>

echo("=== Debug STMJ Socket Calculation ===");
echo("");

echo("Step 1: Target at midpoint of seat tube");
_t_intersection = seat_tube_length / 2;
_stmj_tt_target = bb_seat_tube + seat_tube_unit * _t_intersection;
echo("  _t_intersection:", _t_intersection);
echo("  _stmj_tt_target:", _stmj_tt_target);
echo("");

echo("Step 2: Offset by socket distance");
echo("  tt_socket_distance:", tt_socket_distance);
echo("  -_tt_unit * tt_socket_distance:", -tt_unit * tt_socket_distance);
stmj_calc = _stmj_tt_target - tt_unit * tt_socket_distance;
echo("  stmj_tt_socket_position:", stmj_calc);
echo("");

echo("Actual st_top_tube:", st_top_tube);
echo("Match?", norm(stmj_calc - st_top_tube) < 0.001);
echo("");

echo("Where SHOULD the socket be?");
echo("  From lug: ht_top_tube + top_tube_length * tt_unit");
should_be = ht_top_tube + top_tube_length * tt_unit;
echo("  = ", should_be);
echo("");

echo("Error in current calculation:", norm(st_top_tube - should_be), "mm");
echo("Difference:", st_top_tube - should_be);
