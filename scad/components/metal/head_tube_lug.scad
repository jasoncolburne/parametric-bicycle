// Head Tube Lug
// CNC milled aluminum for NestWorks C500
// Connects head tube to down tube
// Wraps around lower portion of head tube

include <../../config.scad>

// Lug dimensions
lug_height = 60;             // Height along head tube
lug_extension = 50;          // How far it extends for down tube socket
tube_socket_depth = 30;      // How deep down tube inserts

module head_tube_lug() {
    // Calculate directions for socket placement
    // In lug's local frame (Z along head tube toward ht_top):

    // Direction from ht_bottom to bb in global frame
    dt_dir = bb - ht_bottom;
    dt_len = norm(dt_dir);

    // Head tube direction
    ht_dir = ht_top - ht_bottom;

    // Angle between down tube and head tube
    // Down tube comes from below, head tube points up
    dot = dt_dir[0]*ht_dir[0] + dt_dir[2]*ht_dir[2];
    dt_angle_from_ht = acos(dot / (dt_len * norm(ht_dir)));

    difference() {
        union() {
            // Main collar around head tube
            cylinder(h = lug_height, d = head_tube_od + 12);

            // Extension for down tube socket
            // Angle measured from Z axis (along head tube)
            translate([0, 0, lug_height/2])
                rotate([0, dt_angle_from_ht, 0])
                    cylinder(h = lug_extension, d = down_tube_od + 12);
        }

        // Head tube bore (through center)
        translate([0, 0, -epsilon])
            cylinder(h = lug_height + 2*epsilon, d = head_tube_od + socket_clearance);

        // Down tube socket
        translate([0, 0, lug_height/2])
            rotate([0, dt_angle_from_ht, 0])
                translate([0, 0, -epsilon])
                    cylinder(h = tube_socket_depth + lug_extension, d = down_tube_od + socket_clearance);

        // Down tube bolt holes
        translate([0, 0, lug_height/2])
            rotate([0, dt_angle_from_ht, 0])
                translate([0, 0, lug_extension - tube_socket_depth/2])
                    for (i = [0:1])
                        rotate([0, 0, i * 180])
                            rotate([90, 0, 0])
                                cylinder(h = down_tube_od + 20, d = joint_bolt_diameter + 0.5, center = true);

        // Pinch bolt slot (to clamp on head tube)
        translate([head_tube_od/2 + 3, -1, -epsilon])
            cube([10, 2, lug_height + 2*epsilon]);

        // Pinch bolt holes
        for (z = [lug_height * 0.25, lug_height * 0.75]) {
            translate([head_tube_od/2 + 6, 0, z])
                rotate([90, 0, 0])
                    cylinder(h = head_tube_od + 20, d = 5 + 0.5, center = true);  // M5 bolts
        }
    }
}

// Render for preview
head_tube_lug();
