// Head Tube Lug
// CNC milled aluminum for NestWorks C500
// Connects head tube to down tube
// Wraps around lower portion of head tube

include <../../config.scad>

// Lug dimensions
lug_height = 100;             // Height along head tube (increased for top tube clearance)
lug_extension = 90;          // How far it extends for down tube socket
socket_depth = 40;           // How deep down tube inserts
wall_thickness = 4;          // Wall thickness around tubes
top_tube_od = 44;            // Top tube outer diameter
top_tube_extension = 90;     // How far top tube socket extends

// Calculate the actual angle between head tube and downtube in 3D space (global)
ht_vec_global = ht_top - ht_bottom;
dt_vec_global = bb_down_tube - ht_down_tube;
dot_global = ht_vec_global[0]*dt_vec_global[0] + ht_vec_global[1]*dt_vec_global[1] + ht_vec_global[2]*dt_vec_global[2];
dt_angle = acos(dot_global / (norm(ht_vec_global) * norm(dt_vec_global)));

// Calculate the top tube direction (from lug top to seat tube mid-junction)
tt_vec_global = st_top_tube - ht_top_tube;
// Calculate angle relative to head tube axis
tt_dot_global = ht_vec_global[0]*tt_vec_global[0] + ht_vec_global[1]*tt_vec_global[1] + ht_vec_global[2]*tt_vec_global[2];
tt_angle = acos(tt_dot_global / (norm(ht_vec_global) * norm(tt_vec_global)));

module head_tube_lug() {

    // Stepped bore dimensions
    seat_height = 60;  // Height from bottom to seating step (100mm - 40mm clamping = 60mm)
    seat_diameter = head_tube_od + socket_clearance - 4;  // Smaller bore for seating

    // Pinch bolt boss dimensions
    boss_length = 18;  // Increased by 50%
    boss_diameter = 9.5;  // Reduced diameter of boss cylinders
    boss_offset = 1;  // Move bosses outward from cavity for more wall thickness
    boss_translation = (lug_height - seat_height) / 2 + seat_height;
    tap_hole_diameter = 4.2;  // M5 tap drill size
    clearance_hole_diameter = 5.5;  // M5 clearance
    through_hole_position = socket_depth - junction_socket_depth/2;
    bolt_head_clearance = 9.5;  // Clearance for M5 socket head (no raised rim)

    // Head tube dimensions
    lug_outer_radius = (head_tube_od + 2 * wall_thickness) / 2;
    
    // Top tube dimensions
    top_extension_outer_radius = (top_tube_od + 12) / 2;
    top_extension_translation = lug_height - (sin(tt_angle)*top_extension_outer_radius + sin(90-tt_angle) * lug_outer_radius);

    difference() {
        // Build complete solid shape first
        union() {
            // Main collar around head tube
            cylinder(h = lug_height, r = lug_outer_radius);

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

            // Pinch bolt boss - single boss in upper clamping section
            // Positioned at 75% height (45mm) in the clamping zone
            bolt_x = -(head_tube_od/2 + wall_thickness/2) - boss_offset;  // Moved outward
            translate([bolt_x, 0, boss_translation])
                rotate([90, 0, 0]) {
                    // Main cylinder
                    cylinder(h = boss_length, d = boss_diameter, center = true);
                    // Spherical cap on -Z end (the tapped end)
                    translate([0, 0, -boss_length/2])
                        sphere(d = boss_diameter);
                }

            // Extension for top tube socket at top of lug
            // Positioned so outer perimeter is flush with top (lug_height)
            // Socket points toward seat tube mid-junction at calculated tt_angle
            translate([0, 0, top_extension_translation])
                rotate([0, tt_angle, 0])
                    cylinder(h = top_tube_extension, d = top_tube_od + 12);  // 6mm walls

            // Sphere for bolt hole material at top tube socket (at junction_socket_depth/2 from socket start)
            translate([0, 0, top_extension_translation])
                rotate([0, tt_angle, 0])
                    translate([socket_offset, 0, top_tube_extension - socket_depth + junction_socket_depth/2])
                        rotate([90, 0, 0])
                            translate([0, 0, (top_tube_od + 2*6)/2])
                                sphere(r = 8);
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
        // Slot only cuts upper half (above shoulder) for clamping
        // Lower half remains solid ring for structural strength
        slot_x = -(head_tube_od/2 + wall_thickness) - boss_length/2;  // Start far enough out to cut through bosses
        slot_width = wall_thickness + boss_length;  // Wide enough to cut through wall + bosses
        translate([slot_x, -1, seat_height])
            cube([slot_width, 2, lug_height - seat_height + epsilon]);

        // Pinch bolt hole - single bolt at 75% height (45mm)
        bolt_x = -(head_tube_od/2 + wall_thickness/2) - boss_offset;  // Moved outward to match boss

        translate([bolt_x, 0, boss_translation])
            rotate([90, 0, 0]) {
                // Tap hole on -Z end (spherical cap end) - only drills partway
                translate([0, 0, -boss_length/2])
                    cylinder(h = boss_length/2 - 1, d = tap_hole_diameter, center = false);

                // Clearance hole - drills through from center to +Z end and beyond
                translate([0, 0, 1])
                    cylinder(h = boss_length/2 + 20, d = clearance_hole_diameter, center = false);

                translate([0, 0, boss_length/2])
                    cylinder(h = 20, d = bolt_head_clearance, center = false);
            }

        // Top tube socket bore
        lug_collar_radius = (head_tube_od + 2*wall_thickness) / 2;
        socket_offset = lug_collar_radius - top_extension_outer_radius;
        translate([0, 0, top_extension_translation])
            rotate([0, tt_angle, 0])
                translate([socket_offset, 0, top_tube_extension - socket_depth])
                    cylinder(h = socket_depth + epsilon, d = top_tube_od + socket_clearance);

        // Top tube bolt hole (M6 through-bolt) - positioned like downtube bolt
        translate([0, 0, top_extension_translation])
            rotate([0, tt_angle, 0])
                translate([socket_offset, 0, top_tube_extension - socket_depth + junction_socket_depth/2])
                    rotate([90, 0, 0]) {
                        // Tap hole from one side
                        translate([0, 0, (top_tube_od + socket_clearance)/2 - 2])
                            cylinder(h = m6_thread_depth, d = m6_tap_drill);

                        // Clearance hole from opposite side
                        translate([0, 0, -(top_tube_od/2 + 6)])
                            cylinder(h = top_tube_od/2 + 6 - ((top_tube_od + socket_clearance)/2 - 2), d = joint_bolt_diameter + 0.5);

                        // Counterbore for socket head
                        translate([0, 0, -(top_tube_od/2 + 6)])
                            cylinder(h = 2.5, d = 9.5);
                    }
                    
         // Chop the excess top extension off
         translate([0, 0, lug_height])
            cylinder(r=lug_outer_radius, h=50);
    }
}

// Wrapper to reposition origin at downtube socket cap center
module head_tube_lug_repositioned() {
    translate([0, 0, lug_extension-socket_depth])
        rotate([0, 180-dt_angle, 0])
            translate([0, 0, -socket_depth])
                head_tube_lug();
}

// Render for preview
head_tube_lug_repositioned();
