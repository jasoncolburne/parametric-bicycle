include <scad/geometry.scad>

rotation_angle = acos(tt_unit * seat_tube_unit);

echo("rotation_angle:", rotation_angle);
echo("");

// Matrix of collar and sleeve rotations to test
collar_options = [
    ["[angle, 0, 0]", [rotation_angle, 0, 0]],
    ["[-angle, 0, 0]", [-rotation_angle, 0, 0]],
    ["[0, angle, 0]", [0, rotation_angle, 0]],
    ["[0, -angle, 0]", [0, -rotation_angle, 0]],
    ["[0, 0, angle]", [0, 0, rotation_angle]],
    ["[0, 0, -angle]", [0, 0, -rotation_angle]],
];

sleeve_options = [
    ["[180, 0, -90]", [180, 0, -90]],
    ["[180, 0, 90]", [180, 0, 90]],
    ["[-180, 0, -90]", [-180, 0, -90]],
    ["[-180, 0, 90]", [-180, 0, 90]],
    ["[0, 0, -90]", [0, 0, -90]],
    ["[0, 0, 90]", [0, 0, 90]],
    ["[angle, 0, -90]", [rotation_angle, 0, -90]],
    ["[-angle, 0, -90]", [-rotation_angle, 0, -90]],
    ["[180+angle, 0, -90]", [180 + rotation_angle, 0, -90]],
    ["[180-angle, 0, -90]", [180 - rotation_angle, 0, -90]],
];

echo("=== MATRIX: sleeve - collar ===");
for (sleeve = sleeve_options) {
    echo("");
    echo("Sleeve:", sleeve[0]);
    for (collar = collar_options) {
        result = sleeve[1] - collar[1];
        echo("  - collar", collar[0], "=", result);
    }
}
