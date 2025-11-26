// Head Tube Lug
// CNC milled aluminum for NestWorks C500
// Connects head tube to down tube
// Wraps around lower portion of head tube

include <../../config.scad>

// Lug dimensions
lug_height = 50;             // Height along head tube
lug_extension = 50;          // How far it extends for down tube socket (needs to be longer)
socket_depth = 25;           // How deep down tube inserts
wall_thickness = 4;          // Wall thickness around tubes

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

    // Pinch bolt boss dimensions
    boss_length = 18;  // Increased by 50%
    boss_diameter = 12;  // Diameter of boss cylinders
    boss_offset = 1;  // Move bosses outward from cavity for more wall thickness
    tap_hole_diameter = 4.2;  // M5 tap drill size
    clearance_hole_diameter = 5.5;  // M5 clearance
    counterbore_diameter = 9.5;  // M5 socket head
    counterbore_depth = 2.5;  // Counterbore depth

    // Stepped bore dimensions
    seat_height = 10;  // Height from bottom to seating step (below lower pinch bolt)
    seat_diameter = head_tube_od + socket_clearance - 4;  // Smaller bore for seating

    difference() {
        // Build complete solid shape first
        union() {
            // Main collar around head tube
            cylinder(h = lug_height, d = head_tube_od + 2*wall_thickness);

            // Extension for down tube socket (solid)
            translate([0, 0, lug_height/2])
                rotate([0, dt_angle, 0])
                    cylinder(h = lug_extension, d = down_tube_od + 2*wall_thickness);

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

        // Down tube socket bore (starts at beginning of extension, goes through to end)
        translate([0, 0, lug_height/2])
            rotate([0, dt_angle, 0])
                translate([0, 0, -epsilon])
                    cylinder(h = lug_extension + 2*epsilon, d = down_tube_od + socket_clearance);

        // Down tube bolt holes with counterbores
        translate([0, 0, lug_height/2])
            rotate([0, dt_angle, 0])
                translate([0, 0, lug_extension - socket_depth/2])
                    for (angle = [0, 180])
                        rotate([0, 0, angle])
                            rotate([90, 0, 0]) {
                                // Clearance hole for M5 bolt
                                cylinder(h = down_tube_od + 20, d = joint_bolt_diameter + 0.5, center = true);

                                // Counterbore for M5 socket head cap screw (9.5mm dia, 2.5mm deep to preserve 1.5mm contact surface)
                                translate([0, 0, -(down_tube_od/2 + wall_thickness)])
                                    cylinder(h = 2.5, d = 9.5, center = false);
                            }

        // Pinch bolt slot (to clamp on head tube) - 2mm wide slot on FRONT (180° from downtube)
        // Slot must cut through the wall and bosses
        slot_x = -(head_tube_od/2 + wall_thickness) - boss_length/2;  // Start far enough out to cut through bosses
        slot_width = wall_thickness + boss_length;  // Wide enough to cut through wall + bosses
        translate([slot_x, -1, -epsilon])
            cube([slot_width, 2, lug_height + 2*epsilon]);

        // Pinch bolt holes - tap hole on one end, clearance + counterbore on other
        for (z = [lug_height * 0.25, lug_height * 0.75]) {
            bolt_x = -(head_tube_od/2 + wall_thickness/2) - boss_offset;  // Moved outward to match bosses

            translate([bolt_x, 0, z])
                rotate([90, 0, 0]) {
                    // Tap hole on -Z end (spherical cap end) - only drills partway
                    translate([0, 0, -boss_length/2])
                        cylinder(h = boss_length/2 - 1, d = tap_hole_diameter, center = false);

                    // Clearance hole on +Z end - drills from center to end
                    translate([0, 0, 1])
                        cylinder(h = boss_length/2 - 1, d = clearance_hole_diameter, center = false);

                    // Counterbore on +Z end
                    translate([0, 0, boss_length/2 - counterbore_depth])
                        cylinder(h = counterbore_depth + epsilon, d = counterbore_diameter, center = false);

                    // Access cut for counterbore - extends outward from +Z end
                    translate([0, 0, boss_length/2])
                        cylinder(h = 20, d = counterbore_diameter, center = false);
                }
        }
    }
}

// Render for preview
head_tube_lug();
