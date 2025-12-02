include <scad/geometry.scad>

rotation_angle = acos(tt_unit * seat_tube_unit);
collar_rotation = [rotation_angle, 0, 0];

echo("rotation_angle:", rotation_angle);
echo("collar_rotation:", collar_rotation);
echo("");

// Current: sleeve_rotation = [180, 0, -90]
// Net sleeve = [180 - rotation_angle, 0, -90] = [78.4458, 0, -90]

// What if we try different X values in sleeve_rotation?
options = [
    ["Current [180, 0, -90]", [180, 0, -90]],
    ["[rotation_angle, 0, -90]", [rotation_angle, 0, -90]],
    ["[0, 0, -90]", [0, 0, -90]],
    ["[180 - rotation_angle, 0, -90]", [180 - rotation_angle, 0, -90]],
    ["[180 + rotation_angle, 0, -90]", [180 + rotation_angle, 0, -90]],
    ["[-rotation_angle, 0, -90]", [-rotation_angle, 0, -90]],
];

for (opt = options) {
    sleeve = opt[1];
    net = sleeve - collar_rotation;
    echo(opt[0], "-> Net sleeve:", net);
}
