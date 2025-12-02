include <scad/geometry.scad>

rotation_angle = acos(tt_unit * seat_tube_unit);

echo("rotation_angle:", rotation_angle);
echo("");
echo("We want sleeve body to rotate around Y by", rotation_angle, "degrees");
echo("sleeve body rotation = sleeve_rotation - collar_rotation");
echo("");

// Try: collar=[0,0,0], sleeve=[0, rotation_angle, -90]
echo("Option 1: collar=[0,0,0], sleeve=[0,", rotation_angle, ", -90]");
collar1 = [0, 0, 0];
sleeve1 = [0, rotation_angle, -90];
echo("  Net on collar:", sleeve1);
echo("  Net on sleeve:", sleeve1 - collar1);
echo("");

// Try: collar=[0,0,0], sleeve=[180, rotation_angle, -90]
echo("Option 2: collar=[0,0,0], sleeve=[180,", rotation_angle, ", -90]");
collar2 = [0, 0, 0];
sleeve2 = [180, rotation_angle, -90];
echo("  Net on collar:", sleeve2);
echo("  Net on sleeve:", sleeve2 - collar2);
