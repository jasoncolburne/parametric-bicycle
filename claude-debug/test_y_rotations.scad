include <scad/geometry.scad>

rotation_angle = acos(tt_unit * seat_tube_unit);

echo("Target: sleeve gets Y =", rotation_angle);
echo("");

// From matrix, these all give sleeve Y = rotation_angle:
options = [
    ["[180,0,-90] - [0,-angle,0]", [0, -rotation_angle, 0], [180, 0, -90]],
    ["[0,0,-90] - [0,-angle,0]", [0, -rotation_angle, 0], [0, 0, -90]],
    ["[-180,0,-90] - [0,-angle,0]", [0, -rotation_angle, 0], [-180, 0, -90]],
    ["[180,0,90] - [0,-angle,0]", [0, -rotation_angle, 0], [180, 0, 90]],
];

for (opt = options) {
    collar = opt[1];
    sleeve = opt[2];
    net_sleeve = sleeve - collar;
    net_collar = sleeve;

    echo(opt[0]);
    echo("  collar_rotation:", collar);
    echo("  sleeve_rotation:", sleeve);
    echo("  -> Collar gets:", net_collar);
    echo("  -> Sleeve gets:", net_sleeve);
    echo("");
}
