// Head Tube Lug
// CNC milled aluminum for NestWorks C500
// Connects head tube to down tube
// Wraps around lower portion of head tube

include <../../config.scad>

// Lug dimensions
lug_height = 50;             // Height along head tube
lug_extension = 90;          // How far it extends for down tube socket
socket_depth = 40;           // How deep down tube inserts
wall_thickness = 4;          // Wall thickness around tubes

// Calculate the actual angle between head tube and downtube in 3D space (global)
ht_vec_global = ht_top - ht_bottom;
dt_vec_global = bb_down_tube - ht_down_tube;
dot_global = ht_vec_global[0]*dt_vec_global[0] + ht_vec_global[1]*dt_vec_global[1] + ht_vec_global[2]*dt_vec_global[2];
dt_angle = acos(dot_global / (norm(ht_vec_global) * norm(dt_vec_global)));

module head_tube_lug() {

    // Pinch bolt boss dimensions
    boss_length = 18;  // Increased by 50%
    boss_diameter = 9.5;  // Reduced diameter of boss cylinders
    boss_offset = 1;  // Move bosses outward from cavity for more wall thickness
    tap_hole_diameter = 4.2;  // M5 tap drill size
    clearance_hole_diameter = 5.5;  // M5 clearance
    through_hole_position = socket_depth - junction_socket_depth/2;
    bolt_head_clearance = 9.5;  // Clearance for M5 socket head (no raised rim)

    // Stepped bore dimensions
    seat_height = 10;  // Height from bottom to seating step (below lower pinch bolt)
    seat_diameter = head_tube_od + socket_clearance - 4;  // Smaller bore for seating

    difference() {
        // Build complete solid shape first
        union() {
            // Main collar around head tube
            cylinder(h = lug_height, d = head_tube_od + 2*wall_thickness);

            // Extension for down tube socket (solid) - thicker walls for tap depth
            translate([0, 0, lug_height/2])
                rotate([0, dt_angle, 0])
                    cylinder(h = lug_extension, d = down_tube_od + 2*6);  // 6mm wall thickness

            // Sphere for tap hole material at outer hull
            translate([0, 0, lug_height/2])
                rotate([0, dt_angle, 0])
                    translate([0, 0, lug_extension - socket_depth + junction_socket_depth/2])
                        rotate([90, 0, 0])
                            translate([0, 0, (down_tube_od + 2*6)/2])
                                sphere(r = 8);

            // Pinch bolt bosses - cylindrical material for bolt mounting with spherical cap
            for (z = [lug_height * 0.25, lug_height * 0.75]) {
                bolt_x = -(head_tube_od/2 + wall_thickness/2) - boss_offset;  // Moved outward
                // Centered at Y=0, extends in Y direction
                translate([bolt_x, 0, z])
                    rotate([90, 0, 0]) {
                        // Main cylinder
                        cylinder(h = boss_length, d = boss_diameter, center = true);
                        // Spherical cap on -Z end (the tapped end)
                        translate([0, 0, -boss_length/2])
                            sphere(d = boss_diameter);
                    }
            }
        }

        // Cut all holes through the solid
        // Head tube bore - two sections to create seating step
        // Lower section: larger diameter, extends below lug to clear downtube sleeve
        translate([0, 0, -lug_height - epsilon])
            cylinder(h = lug_height + seat_height + epsilon, d = head_tube_od + socket_clearance);

        // Upper section: smaller diameter, head tube seats on the step
        translate([0, 0, seat_height])
            cylinder(h = lug_height - seat_height + epsilon, d = head_tube_od + socket_clearance - 4);

        // Down tube socket bore (only as deep as needed for tube insertion)
        translate([0, 0, lug_height/2])
            rotate([0, dt_angle, 0])
                translate([0, 0, lug_extension - socket_depth])
                    cylinder(h = socket_depth + epsilon, d = down_tube_od + socket_clearance);

        // Down tube bolt holes - one tapped side, one counterbored side
        translate([0, 0, lug_height/2])
            rotate([0, dt_angle, 0])
                translate([0, 0, lug_extension - socket_depth + junction_socket_depth/2])
                    rotate([90, 0, 0]) {
                        // Tap hole - starts 2mm inside socket bore, extends outward
                        tap_start = (down_tube_od + socket_clearance)/2 - 2;
                        translate([0, 0, tap_start])
                            cylinder(h = m6_thread_depth, d = m6_tap_drill, center = false);

                        // Clearance hole - from opposite side through to tap
                        translate([0, 0, -(down_tube_od/2 + 6)])
                            cylinder(h = down_tube_od/2 + 6 - tap_start, d = joint_bolt_diameter + 0.5, center = false);

                        // Counterbore for M5 socket head cap screw
                        translate([0, 0, -(down_tube_od/2 + 6)])
                            cylinder(h = 2.5, d = 9.5, center = false);
                    }

        // Pinch bolt slot (to clamp on head tube) - 2mm wide slot on FRONT (180° from downtube)
        // Slot must cut through the wall and bosses
        slot_x = -(head_tube_od/2 + wall_thickness) - boss_length/2;  // Start far enough out to cut through bosses
        slot_width = wall_thickness + boss_length;  // Wide enough to cut through wall + bosses
        translate([slot_x, -1, -epsilon])
            cube([slot_width, 2, lug_height + 2*epsilon]);

        // Pinch bolt holes - tap hole on one end, clearance on other (no raised rim)
        for (z = [lug_height * 0.25, lug_height * 0.75]) {
            bolt_x = -(head_tube_od/2 + wall_thickness/2) - boss_offset;  // Moved outward to match bosses

            translate([bolt_x, 0, z])
                rotate([90, 0, 0]) {
                    // Tap hole on -Z end (spherical cap end) - only drills partway
                    translate([0, 0, -boss_length/2])
                        cylinder(h = boss_length/2 - 1, d = tap_hole_diameter, center = false);

                    // Clearance hole - drills through from center to +Z end and beyond
                    translate([0, 0, 1])
                        cylinder(h = boss_length/2 + 20, d = clearance_hole_diameter, center = false);
                }

            // Separate cut from union to provide bolt head clearance (cuts through collar)
            translate([bolt_x, 0, z])
                rotate([90, 0, 0])
                    translate([0, 0, boss_length/2])
                        cylinder(h = 20, d = bolt_head_clearance, center = false);
        }
    }
}

// Wrapper to reposition origin at downtube socket cap center
module head_tube_lug_repositioned() {
    // Move origin from base of lug to center of downtube socket cap
    // Socket opening is at: lug_height/2 + lug_extension along head tube Z-axis
    // Then angled at dt_angle
    // First translate back along Z, then rotate so angled socket points along +Z
    translate([0, 0, lug_extension-socket_depth])
        rotate([0, 180-dt_angle, 0])
            translate([0, 0, -junction_socket_depth])
                head_tube_lug();
}

// Render for preview
head_tube_lug_repositioned();
