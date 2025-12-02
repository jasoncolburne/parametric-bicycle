include <scad/geometry.scad>

// From seat_tube_junction.scad - calculate seat stay directions
ss_left_start = st_seat_stay_base + [-ss_spread, 0, 0];
ss_right_start = st_seat_stay_base + [ss_spread, 0, 0];
ss_left_end = dropout + [-ss_spread, 0, dropout_seat_stay_z];
ss_right_end = dropout + [ss_spread, 0, dropout_seat_stay_z];

ss_left_dir = ss_left_end - ss_left_start;
ss_right_dir = ss_right_end - ss_right_start;

// From geometry.scad - the global calculation
global_ss_start = st_seat_stay_base + [0, ss_spread, 0];
global_ss_end = dropout + [0, ss_spread, dropout_seat_stay_z];
global_ss_dir = global_ss_end - global_ss_start;

echo("Component ss_right_start:", ss_right_start);
echo("Global ss_start:", global_ss_start);
echo("Component ss_right_dir:", ss_right_dir);
echo("Global ss_dir:", global_ss_dir);
echo("Difference in start:", ss_right_start - global_ss_start);
echo("Normalized component right:", ss_right_dir / norm(ss_right_dir));
echo("Normalized global:", global_ss_dir / norm(global_ss_dir));
