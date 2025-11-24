// Head Tube Lug
// CNC milled aluminum for NestWorks C500
// Connects head tube to down tube
// Wraps around lower portion of head tube

include <../../config.scad>

// Lug dimensions
lug_height = 60;             // Height along head tube
lug_extension = 50;          // How far it extends for down tube socket
socket_depth = 30;           // How deep down tube inserts

module head_tube_lug() {
    // This lug is positioned along the head tube axis
    // It's placed with: orient_to(ht_bottom, ht_top)
    // So its local Z axis points along the head tube direction (upward)

    // Down tube connects at ht_down_tube and goes to bb_down_tube
    // In world coords: from ht_down_tube to bb_down_tube

    // Calculate down tube direction relative to head tube axis
    dt_dir = bb_down_tube - ht_down_tube;
    ht_dir = ht_top - ht_bottom;

    // Angle between down tube and head tube
    dot_product = dt_dir[0]*ht_dir[0] + dt_dir[2]*ht_dir[2];
    dt_angle = acos(dot_product / (norm(dt_dir) * norm(ht_dir)));

    difference() {
        union() {
            // Main collar around head tube
            cylinder(h = lug_height, d = head_tube_od + 12);

            // Extension for down tube socket
            translate([0, 0, lug_height/2])
                rotate([0, dt_angle, 0])
                    cylinder(h = lug_extension, d = down_tube_od + 12);
        }

        // Head tube bore (through center)
        translate([0, 0, -1])
            cylinder(h = lug_height + 2, d = head_tube_od + socket_clearance);

        // Down tube socket
        translate([0, 0, lug_height/2])
            rotate([0, dt_angle, 0])
                translate([0, 0, -1])
                    cylinder(h = socket_depth + lug_extension, d = down_tube_od + socket_clearance);

        // Down tube bolt holes
        translate([0, 0, lug_height/2])
            rotate([0, dt_angle, 0])
                translate([0, 0, lug_extension - socket_depth/2])
                    for (angle = [0, 180])
                        rotate([0, 0, angle])
                            rotate([90, 0, 0])
                                cylinder(h = down_tube_od + 20, d = joint_bolt_diameter + 0.5, center = true);

        // Pinch bolt slot (to clamp on head tube)
        translate([head_tube_od/2 + 3, -1, -1])
            cube([10, 2, lug_height + 2]);

        // Pinch bolt holes
        for (z = [lug_height * 0.25, lug_height * 0.75]) {
            translate([head_tube_od/2 + 6, 0, z])
                rotate([90, 0, 0])
                    cylinder(h = head_tube_od + 20, d = 5.5, center = true);
        }
    }
}

// Render for preview
head_tube_lug();
