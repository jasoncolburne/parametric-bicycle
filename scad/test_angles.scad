include <geometry.scad>

echo("bb_down_tube=", bb_down_tube);
echo("ht_target=", ht_target);
echo("ht_down_tube=", ht_down_tube);
echo("down_tube_length=", down_tube_length);
echo("down_tube_angle=", down_tube_angle);
echo("dt_socket_depth=", tube_socket_depth(DOWN_TUBE));
echo("distance bb to ht_target=", norm(ht_target - bb_down_tube));
echo("distance bb to ht_down_tube=", norm(ht_down_tube - bb_down_tube));
