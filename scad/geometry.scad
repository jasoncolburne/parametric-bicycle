// Ebike Configuration
// All dimensions in mm

// =============================================================================
// PRIMITIVES LIBRARY
// =============================================================================
include <lib/bolt_sizes.scad>
include <lib/tube_sizes.scad>
include <lib/helpers.scad>

// =============================================================================
// RIDER PARAMETERS
// =============================================================================
rider_height = 173;
rider_weight = 55;

// =============================================================================
// WHEEL CONFIGURATION
// =============================================================================
wheel_size = "27.5";             // 27.5" / 650b
wheel_bsd = 584;                  // Bead seat diameter (mm) - ISO 584
wheel_tire_width = 50;            // Recommended tire width (mm) - 50-55mm range
wheel_diameter = wheel_bsd + 2 * wheel_tire_width;  // 684mm total diameter

// =============================================================================
// FRAME GEOMETRY - FUNDAMENTAL PARAMETERS
// =============================================================================
// These are the PRIMARY inputs that define the bike geometry
// All other geometry is DERIVED from these values

// Fit parameters (define rider position)
reach = 392;                         // Horizontal BB to head tube top
stack = 633;                         // Vertical BB to head tube top
standover_height = 450;              // Clearance for step-through

// Tube angles (define frame shape)
head_tube_angle = 70;                // Degrees from horizontal
seat_tube_angle = 72;                // Degrees from horizontal
head_tube_length = 140;              // Physical length of head tube

// Rear triangle parameters
bb_drop = 77.5;                      // BB below rear axle line
chainstay_to_reach_ratio = 1.23;    // Chainstay horizontal length as proportion of reach
                                     // Typical: 1.2-1.3 for balanced handling

// Additional parameters
tt_angle = 105;                      // Top tube angle with respect to head tube
frame_size = 520;                    // Seat tube center-to-top (TODO: derive from standover)

// =============================================================================
// TUBE DIAMETERS
// =============================================================================
// All tube dimensions derived from tube_sizes.scad
head_tube_od = tube_outer_radius(HEAD_TUBE) * 2;
head_tube_id = head_tube_od - tube_thickness(HEAD_TUBE) * 2;
seat_tube_od = tube_outer_radius(SEAT_TUBE) * 2;
seat_tube_id = tube_outer_radius(SEAT_POST) * 2;  // Seatpost OD = seat tube ID
down_tube_od = tube_outer_radius(DOWN_TUBE) * 2;
top_tube_od = tube_outer_radius(TOP_TUBE) * 2;
chainstay_od = tube_outer_radius(CHAINSTAY) * 2;
seat_stay_od = tube_outer_radius(SEATSTAY) * 2;

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
seat_collar_id = seat_tube_od + 2 * tube_socket_clearance(SEAT_POST);
seat_collar_od = seat_collar_id + 2 * tube_collar_thickness(SEAT_POST);
seat_collar_height = 25;

// =============================================================================
// MOTOR MOUNT
// =============================================================================
motor_mount_thickness = 8;
motor_mount_width = 120;
motor_mount_height = 100;

// =============================================================================
// BATTERY AND WATER BOTTLE MOUNTING (RIVNUTS)
// =============================================================================
// Standard water bottle cage spacing (also used for battery)
bottle_cage_spacing = 74;            // Standard spacing (mm)
bottle_cage_bolt = 5;                // M5 bolts
rivnut_hole_diameter = 9;            // 9mm hole for M5 rivnut installation
rivnut_body_length = 10;             // Rivnut body length for clearance

// Rivnut positions in downtube section 1:
// - 2 rivnuts at -90° (bottom) for Varstrom battery bracket
// - 2 rivnuts at +90° (top) for water bottle cage
// - Both centered at Z = 80mm and 154mm (74mm spacing)

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

// =============================================================================
// DERIVED GEOMETRY - CALCULATED FROM FUNDAMENTALS
// =============================================================================
// All positions calculated from reach, stack, angles, and chainstay length
// BB is at origin [0, 0, 0]

// --- PRIMARY JUNCTION POSITIONS ---

// Head tube bottom (where down tube connects)
ht_bottom_x = reach + head_tube_length * cos(head_tube_angle);
ht_bottom_z = stack - head_tube_length * sin(head_tube_angle);
ht_top = [reach, 0, stack];
ht_bottom = [ht_bottom_x, 0, ht_bottom_z];

// Head tube unit vector
_ht_vec = ht_top - ht_bottom;
ht_unit = _ht_vec / norm(_ht_vec);

// Down tube lug position (50mm up head tube from bottom)
down_tube_extension_translation = 50;
ht_target = ht_bottom + ht_unit * down_tube_extension_translation;

// Dropout position (rear axle) - derived from reach proportion
// BB drop means BB is BELOW the rear axle, so dropout Z is positive
chainstay_horizontal_length = reach * chainstay_to_reach_ratio;
dropout_x = -chainstay_horizontal_length;  // Behind BB (negative X)
dropout_z = bb_drop;                       // Above BB (positive Z)

// --- TUBE ANGLES AT BB JUNCTION ---
// All angles measured from horizontal (positive = upward)

// Down tube angle (origin to ht_target)
down_tube_angle = atan2(ht_target[2], ht_target[0]);

// Seat tube angle (given as input, measured from horizontal)
// seat_tube_angle is already defined above

// Chainstay angle (BB to dropout, typically negative/downward)
chainstay_angle = atan2(dropout_z, dropout_x);

// --- BB JUNCTION COLLAR CONFIGURATION ---
// Collars extend perpendicular from Y-oriented BB shell
// Down tube: points forward at down_tube_angle from +X
// Seat tube: points backward at seat_tube_angle from +X (need to add 180°)
//
// Sockets were pointing backward, need 180° flip around Z
bb_dt_collar_rotation = [0, -90+down_tube_angle, 180];
bb_dt_collar_height = 0;

bb_st_collar_rotation = [0, 90-seat_tube_angle, 180];
bb_st_collar_height = 0;

// Collar internal rotation (applied within Collar constructor)
bb_dt_collar_internal_rotation = [0, 0, -90];
bb_st_collar_internal_rotation = [0, 0, -90];

// --- BB JUNCTION SOCKET POSITIONS ---
// Socket positions calculated from collar geometry
// Socket is at extension_depth - socket_depth along the rotated collar axis
dt_socket_distance = tube_extension_depth(DOWN_TUBE) - tube_socket_depth(DOWN_TUBE);
bb_down_tube = [
    dt_socket_distance * cos(down_tube_angle),
    0,
    dt_socket_distance * sin(down_tube_angle)
];

st_socket_distance = tube_extension_depth(SEAT_TUBE) - tube_socket_depth(SEAT_TUBE);
bb_seat_tube = [
    st_socket_distance * cos(180-seat_tube_angle),
    0,
    st_socket_distance * sin(180-seat_tube_angle)
];

// Chainstay sockets: positioned at ±spread in Y direction
cs_spread = 60;  // Chainstay spread for mid-drive motor clearance
bb_chainstay_z = 0;  // Chainstay exits at BB centerline

// --- SEAT TUBE TOP POSITION ---
// Calculate based on standover requirement or frame size
// Using frame_size for now (TODO: derive from standover)
st_top_x = -frame_size * cos(seat_tube_angle);
st_top_z = frame_size * sin(seat_tube_angle);
st_top = [st_top_x, 0, st_top_z];

// --- DROPOUT POSITIONS ---
dropout = [dropout_x, 0, dropout_z];
dropout_chainstay_z = 30;  // Raised to clear axle
dropout_seat_stay_z = 60;  // Raised proportionally

// --- SEAT TUBE JUNCTION ---
stj_height = 60;                    // Total junction height
st_seat_stay_collar_height = tube_socket_depth(SEAT_TUBE);  // Collar height based on seat tube socket depth

// --- SEAT STAY POSITIONS ---
ss_spread = 35;  // Seat stay spread (narrower than chainstay)

// Calculate seat stay start positions accounting for seat tube angle
st_vec = st_top - bb_seat_tube;
st_unit = st_vec / norm(st_vec);  // Seat tube direction unit vector
// Seat stays start such that their socket end inserts into the collar socket
// Position the tube so socket entrance is at st_top (collar socket entrance)
ss_socket_depth = tube_socket_depth(SEATSTAY);
ss_extension_depth = tube_extension_depth(SEATSTAY);
// Calculate direction from collar to dropout
ss_dir_vec = dropout + [0, ss_spread, dropout_seat_stay_z] - st_top;
ss_dir_unit = ss_dir_vec / norm(ss_dir_vec);
st_seat_stay_base = st_top + (ss_extension_depth - ss_socket_depth) * ss_dir_unit;  // Move forward to socket entrance

// --- WHEELBASE ---
wheelbase = ht_bottom_x - dropout_x;  // Horizontal distance between axles

// --- TUBE LENGTHS ---
// Calculate actual tube lengths including socket insertions

// Down tube socket position at head tube lug
ht_down_tube = ht_target;

// Down tube length
down_tube_length = norm(ht_down_tube - bb_down_tube);

// Seat tube: BB junction to seat tube top
seat_tube_length = norm(st_top - bb_seat_tube);

// Chainstays: BB junction to dropout (with spread)
cs_start = [0, cs_spread, bb_chainstay_z];
cs_end = dropout + [0, cs_spread, dropout_chainstay_z];
chainstay_length = norm(cs_end - cs_start);

// Seat stays: Seat tube junction collar position to dropout (with spread)
ss_start = st_seat_stay_base + [0, ss_spread, 0];
ss_end = dropout + [0, ss_spread, dropout_seat_stay_z];
seat_stay_length = norm(ss_end - ss_start);

// Down tube gusset angle (for step-through bend)
down_tube_gusset_angle = 150;        // Angle between sections at gusset (degrees)

// =============================================================================
// TUBE JOINTS
// =============================================================================
// Joint design: internal aluminum sleeve with M6 through-bolts
joint_overlap = 30;                  // Overlap length per joint
joint_bolt_diameter = 6;             // M6 bolts
joint_bolt_count = 2;                // Bolts per joint

// Sleeve parameters (CNC milled aluminum)
sleeve_wall_thickness = 2;
sleeve_length = 60;                  // Total sleeve length (2x overlap)

// Bolt hole cutting length (must exceed max tube OD)
bolt_hole_length = 75;

// M6 socket head cap screw specifications
m6_socket_head_diameter = 10;         // Socket head cap diameter
m6_socket_head_height = 6;            // Socket head cap height
m6_tap_drill = 5.0;                   // Tap drill diameter for M6 x 1.0 in aluminum
m6_counterbore_depth = 7;             // Counterbore depth (6mm head + 1mm clearance)
m6_thread_depth = 12;                 // Threaded hole depth (2x bolt diameter)

// =============================================================================
// MANUFACTURING TOLERANCES
// =============================================================================
tolerance_press_fit = 0.05;
tolerance_general = 0.1;

// Socket clearance for tube-to-junction fit (on diameter)
// Accounts for: CNC ±0.02mm + 3D print ±0.2mm on each radius
// Total potential interference: 0.44mm on diameter
// 0.3mm provides tighter fit with CNC precision
socket_clearance = 0.3;

// =============================================================================
// DISPLAY COLORS (for assembly visualization)
// =============================================================================
color_metal = "silver";
color_plastic = "white";

// =============================================================================
// COMMON CONSTANTS
// =============================================================================
// Circle resolution based on manufacturing precision
fn_cnc = 512;                        // CNC milled parts (±0.02mm precision)
fn_print = 256;                       // 3D printed parts (±0.2mm precision)
fn_assembly = 64;                    // Assembly preview (for performance)

$fn = fn_cnc;                        // Default to CNC precision
epsilon = 0.01;                      // For boolean operations

// =============================================================================
// =============================================================================
// EXPORTED FRAME POINTS (for assembly and components)
// =============================================================================
// These are the clean, derived positions used throughout the codebase

// Primary junctions
bb = [0, 0, 0];  // BB center at origin

// BB junction socket positions are already calculated above as:
// - bb_down_tube
// - bb_seat_tube
// - bb_chainstay_z (Z coordinate, spread handled separately)

// Head tube lug connection is already calculated above as:
// - ht_down_tube

// Seat tube positions are already calculated above as:
// - st_top
// - st_seat_stay_z

// Dropout positions are already calculated above as:
// - dropout
// - dropout_chainstay_z
// - dropout_seat_stay_z

// Spreads are already calculated above as:
// - cs_spread
// - ss_spread

// Lug dimensions
lug_height = 100;

_dt_vec = bb_down_tube - ht_down_tube;
_ht_dot_dt = _ht_vec[0]*_dt_vec[0] + _ht_vec[1]*_dt_vec[1] + _ht_vec[2]*_dt_vec[2];
dt_angle = acos(_ht_dot_dt / (norm(_ht_vec) * norm(_dt_vec)));

dt_unit = _dt_vec / norm(_dt_vec);

// Top tube direction: rotate head tube direction by tt_angle around global Y-axis
tt_unit = [
    ht_unit[0] * cos(tt_angle) - ht_unit[2] * sin(tt_angle),
    ht_unit[1],
    ht_unit[0] * sin(tt_angle) + ht_unit[2] * cos(tt_angle)
];

// Head tube dimensions
lug_outer_radius = head_tube_od / 2 + tube_collar_thickness(HEAD_TUBE);
lug_collar_radius = lug_outer_radius;
top_extension_outer_radius = top_tube_od / 2 + tube_collar_thickness(TOP_TUBE);
socket_offset = lug_collar_radius - top_extension_outer_radius;
alpha = 180 - tt_angle;
x = lug_outer_radius;
y = top_extension_outer_radius;
top_extension_offset = sin(alpha)*y-(x-cos(alpha)*y)/tan(alpha);
top_extension_translation = lug_height - top_extension_offset - down_tube_extension_translation;

// Build up socket position step by step for debugging
_tt_step1 = ht_down_tube;
_tt_step2 = _tt_step1 - dt_unit * (tube_extension_depth(DOWN_TUBE) - tube_socket_depth(DOWN_TUBE));
_tt_step3 = _tt_step2 + ht_unit * top_extension_translation;
_tt_step4 = _tt_step3 + tt_unit * (tube_extension_depth(TOP_TUBE) - tube_socket_depth(TOP_TUBE));
lug_tt_socket_position = _tt_step4;

// Seat tube mid-junction socket position
// Project from lug socket along tt_unit to seat tube centerline
// Seat tube runs from bb_seat_tube to st_top
_st_vec = st_top - bb_seat_tube;
_st_unit = _st_vec / norm(_st_vec);

// Find intersection: lug_tt_socket_position + t*tt_unit = bb_seat_tube + s*seat_tube_unit
// This is a line-line closest approach problem in 3D
_w0 = bb_seat_tube - lug_tt_socket_position;
_a = _st_unit * _st_unit;  // = 1 (unit vector)
_b = _st_unit * tt_unit;   // dot product
_c = tt_unit * tt_unit;    // = 1 (unit vector)
_d = _st_unit * _w0;       // dot product
_e = tt_unit * _w0;        // dot product
_t_intersection = (_b * _e - _c * _d) / (_a * _c - _b * _b);
// Point on seat tube axis where top tube ray intersects
_st_intersection_point = bb_seat_tube + _st_unit * _t_intersection;
// Back up by extension offset along -tt_unit to place junction socket entrance
seat_tube_mid_junction_position = _st_intersection_point - tt_unit * (tube_extension_depth(TOP_TUBE) - tube_socket_depth(TOP_TUBE));

// Top tube length from socket to socket
top_tube_length = norm(seat_tube_mid_junction_position - lug_tt_socket_position);

// Seat tube mid-junction orientation angles
// Socket should point toward lug (opposite of tt_unit)
_tt_inv = -tt_unit;
stmj_socket_rotation_y = atan2(_tt_inv[0], _tt_inv[2]);  // Rotation around Y axis
stmj_socket_rotation_x = atan2(_tt_inv[1], sqrt(_tt_inv[0]*_tt_inv[0] + _tt_inv[2]*_tt_inv[2]));  // Rotation around X axis

// Export for assembly (after calculations)
ht_top_tube = lug_tt_socket_position;  // Top tube socket position in lug
st_top_tube = seat_tube_mid_junction_position;  // Seat tube mid-junction socket position

// Seat tube mid-junction bolt positioning
// The sleeve has two tapped bolts at tap_unit and tap_unit*2 from sleeve bottom
stmj_height = 70;  // Height of seat tube mid-junction sleeve
stmj_tap_unit = stmj_height / 3;

// Work along the seat tube axis:
// 1. _t_intersection is where top tube intersects seat tube (distance from bb_seat_tube)
// 2. Move down seat tube axis by stmj_height/2 to get to sleeve bottom
// 3. Move back up by tap_unit and tap_unit*2 for bolt positions
_st_sleeve_bottom_distance = _t_intersection - stmj_height / 2;
st_mid_junction_bolt1_distance = _st_sleeve_bottom_distance + stmj_tap_unit;
st_mid_junction_bolt2_distance = _st_sleeve_bottom_distance + stmj_tap_unit * 2;

// Debug exports for visualization
tt_step1 = _tt_step1;
tt_step2 = _tt_step2;
tt_step3 = _tt_step3;
tt_step4 = _tt_step4;

// =============================================================================
// HELPER MODULE: Orient object from point A toward point B
// =============================================================================
module orient_to(from, to) {
    dx = to[0] - from[0];
    dy = to[1] - from[1];
    dz = to[2] - from[2];

    // Calculate rotation angles
    ax = atan2(dy, sqrt(dx*dx + dz*dz));
    az = atan2(dx, dz);

    translate(from)
        rotate([0, az, 0])
            rotate([-ax, 0, 0])
                children();
}
