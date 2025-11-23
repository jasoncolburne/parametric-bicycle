// Ebike Configuration
// All dimensions in mm

// =============================================================================
// RIDER PARAMETERS
// =============================================================================
rider_height = 173;
rider_weight = 55;

// =============================================================================
// FRAME GEOMETRY
// =============================================================================
frame_size = 520;                    // Seat tube center-to-top
top_tube_effective = 545;
head_tube_length = 140;
head_tube_angle = 70;
seat_tube_angle = 72;
chainstay_length = 460;
bb_drop = 65;
wheelbase = 1080;
standover_height = 450;              // Step-through
stack = 620;
reach = 370;

// =============================================================================
// TUBE DIAMETERS
// =============================================================================
head_tube_id = 44;                   // 1-1/8" straight steerer
head_tube_od = 49;
seat_tube_id = 27.2;                 // Standard seatpost
down_tube_od = 44;
top_tube_od = 32;
seat_stay_od = 16;
chainstay_od = 22;

// =============================================================================
// MOTOR CONFIGURATION
// =============================================================================
motor_type = "mid-drive";
bb_shell_width = 68;                 // BSA standard
bb_clearance_width = 120;

// =============================================================================
// DROPOUT PARAMETERS
// =============================================================================
dropout_material = "6061-T6";
dropout_thickness = 10;
dropout_width = 45;
dropout_height = 80;
dropout_axle_spacing = 142;          // Boost thru-axle
dropout_axle_diameter = 12;

// =============================================================================
// BOTTOM BRACKET SHELL
// =============================================================================
bb_shell_od = 42;
bb_shell_id = 34.8;                  // BSA threaded
bb_thread_tpi = 24;                  // BSA 1.37" x 24 TPI

// =============================================================================
// HEAD TUBE
// =============================================================================
// Uses head_tube_length, head_tube_id, head_tube_od from above

// =============================================================================
// SEAT COLLAR
// =============================================================================
seat_collar_id = 31.8;               // For 27.2mm post with shim
seat_collar_od = 38;
seat_collar_height = 25;

// =============================================================================
// MOTOR MOUNT
// =============================================================================
motor_mount_thickness = 8;
motor_mount_width = 120;
motor_mount_height = 100;

// =============================================================================
// BATTERY MOUNT
// =============================================================================
battery_mount_thickness = 6;
battery_mount_width = 60;
battery_mount_height = 40;
battery_mount_quantity = 4;

// =============================================================================
// BRAKE MOUNT (Post Mount)
// =============================================================================
brake_mount_thickness = 10;
brake_mount_width = 80;
brake_mount_height = 50;
brake_post_bolt_spacing = 74;        // Post mount standard
brake_rotor_size_front = 180;
brake_rotor_size_rear = 160;

// =============================================================================
// CABLE GUIDES
// =============================================================================
cable_guide_length = 25;
cable_guide_width = 15;
cable_guide_height = 8;
cable_guide_quantity = 6;

// =============================================================================
// HEADSET CUPS
// =============================================================================
headset_cup_od = 44;
headset_bearing_seat = 30;

// =============================================================================
// RACK/FENDER MOUNTS
// =============================================================================
rack_mount_length = 30;
rack_mount_width = 20;
rack_mount_height = 10;
rack_mount_thread = 5;               // M5
rack_mount_quantity = 4;

// =============================================================================
// GUSSET PLATES
// =============================================================================
gusset_thickness = 6;
gusset_width = 80;
gusset_height = 60;
gusset_quantity = 2;

// =============================================================================
// COMPOSITE FRAME TUBES (FibreSeeker 3)
// =============================================================================
// Wall thickness for carbon fiber reinforced tubes
tube_wall_thickness = 3;

// Down tube (curved for step-through)
down_tube_length = 650;              // Along curve
down_tube_curve_radius = 800;        // Radius of curve

// Seat tube
seat_tube_length = 520;              // frame_size
seat_tube_od = 34;                   // Outer diameter

// Chainstays
chainstay_wall = 2.5;

// Seat stays
seat_stay_length = 480;
seat_stay_wall = 2;

// =============================================================================
// TUBE SECTIONING (for build volume constraints)
// =============================================================================
// Joint design: internal aluminum sleeve with M6 through-bolts
joint_overlap = 30;                  // Overlap length per joint
joint_bolt_diameter = 6;             // M6 bolts
joint_bolt_count = 2;                // Bolts per joint

// Section counts
down_tube_sections = 3;
seat_tube_sections = 2;
chainstay_sections = 2;
seat_stay_sections = 2;

// Sleeve parameters (CNC milled aluminum) - for straight tubes
sleeve_wall_thickness = 2;
sleeve_length = 60;                  // Total sleeve length (2x overlap)

// Flange joint parameters (for curved down tube)
flange_thickness = 6;
flange_width = 60;                   // Width of flange plate
flange_height = 40;                  // Height of flange plate
flange_bolt_count = 4;               // Bolts per flange pair
flange_bolt_diameter = 6;            // M6 bolts
lap_overlap = 25;                    // Tube overlap at joint

// Bolt hole cutting length (must exceed max tube OD)
bolt_hole_length = 75;

// =============================================================================
// MANUFACTURING TOLERANCES
// =============================================================================
tolerance_press_fit = 0.05;
tolerance_general = 0.1;

// =============================================================================
// COMMON CONSTANTS
// =============================================================================
$fn = 64;                            // Circle resolution
epsilon = 0.01;                      // For boolean operations
