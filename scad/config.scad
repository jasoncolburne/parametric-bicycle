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
// FRAME GEOMETRY
// =============================================================================
frame_size = 520;                    // Seat tube center-to-top
top_tube_effective = 545;
head_tube_length = 140;
head_tube_angle = 70;
seat_tube_angle = 72;
chainstay_length = 460;
bb_drop = 77.5;                      // 27.5" wheel radius (342mm) - target BB height (264.5mm) = 77.5mm
wheelbase = 1078;                    // Recalculated from dropout position (was 1080)
standover_height = 450;              // Step-through
stack = 633;                         // Increased for larger front wheel (was 620)
reach = 375;
tt_angle = 108; // top tube angle with respect to head tube

// =============================================================================
// TUBE DIAMETERS
// =============================================================================
head_tube_id = 44;                   // 1-1/8" straight steerer
head_tube_od = 49;
seat_tube_id = 27.2;                 // Standard seatpost
down_tube_od = 44;
top_tube_od = 44;                    // Same as down tube for structural strength
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
// Wall thickness for carbon fiber reinforced tubes
tube_wall_thickness = 3;

// Build volume constraint
max_section_length = 245;            // FibreSeeker 3 Z height

// --- CALCULATED FRAME DISTANCES ---
// Head tube bottom position
ht_bottom_x = reach + head_tube_length * cos(head_tube_angle);
ht_bottom_z = stack - head_tube_length * sin(head_tube_angle);

// Seat tube
seat_tube_od = 34;                   // Outer diameter

// Seat tube top position (from origin along seat tube angle)
st_top_x = -frame_size * cos(seat_tube_angle);
st_top_z = frame_size * sin(seat_tube_angle);

// Dropout position - recalculates when bb_drop changes (wheel size dependent)
dropout_x = -sqrt(pow(chainstay_length, 2) - pow(bb_drop, 2));
dropout_z = -bb_drop;

// Chainstay and seat stay wall thickness
chainstay_wall = 2.5;
seat_stay_wall = 2;

// --- CONNECTION POINT OFFSETS ---
// These offsets position tube connections to clear the BB bore
// BB bore radius = bb_shell_od/2 = 21mm
_bb_down_tube_offset = [25, 0, bb_shell_od/2 + down_tube_od/2 + 3];
_bb_seat_tube_offset = [-15, 0, bb_shell_od/2 + seat_tube_od/2 + 3];
_bb_chainstay_z = -(bb_shell_od/2 + chainstay_od/2 + 3);

// Head tube connection (down tube connects 42mm up from bottom)
_ht_down_tube = [ht_bottom_x, 0, ht_bottom_z + 42];

// Seat tube top and seat stay connection
_st_top = [st_top_x, 0, st_top_z];
_st_seat_stay_z = -15;

// Dropout connections
_dropout = [dropout_x, 0, dropout_z];
_dropout_chainstay_z = 30;              // Raised to clear axle with structural material (chainstay_od/2 + axle_d/2 + 8mm wall)
_dropout_seat_stay_z = 60;              // Raised proportionally

// Spreads
_cs_spread = 60;                      // Chainstay spread at BB and dropout
_ss_spread = 35;                      // Seat stay spread (inward from chainstay to avoid collision)

// --- SOCKET DEPTH FOR JUNCTIONS ---
junction_socket_depth = 25;  // How deep tubes insert into junction sockets

// --- ACTUAL TUBE LENGTHS (from connection points + socket insertion) ---
// Tubes extend from connection point to connection point, PLUS socket depth at each end

// Down tube: from ht_down_tube to bb_down_tube + socket depth at each end
// BB end: junction_socket_depth (25mm), Head tube end: socket_depth from lug (40mm)
_down_tube_core = norm(_bb_down_tube_offset - _ht_down_tube);
down_tube_length = _down_tube_core + junction_socket_depth + 40;  // 25mm BB + 40mm lug

// Seat tube: from bb_seat_tube to st_top
// BB end: full socket depth insertion (25mm)
// Top end: partial insertion into seat tube junction (35mm into 60mm junction)
_seat_tube_core = norm(_st_top - _bb_seat_tube_offset);
seat_tube_length = _seat_tube_core + junction_socket_depth - 25;

// Chainstay: from [0, cs_spread, bb_chainstay_z] to dropout + [0, cs_spread, dropout_chainstay_z]
_cs_start = [0, _cs_spread, _bb_chainstay_z];
_cs_end = _dropout + [0, _cs_spread, _dropout_chainstay_z];
_chainstay_core = norm(_cs_end - _cs_start);
chainstay_actual_length = _chainstay_core + 2 * junction_socket_depth;

// Seat stay: from st_top + [0, ss_spread, st_seat_stay_z] to dropout + [0, ss_spread, dropout_seat_stay_z]
// Keep at ss_spread for structural rigidity (no convergence with chainstay)
// Seat tube junction end: only 12.5mm insertion (socket starts at Z=5)
// Dropout junction end: full 25mm insertion
_ss_start = _st_top + [0, _ss_spread, _st_seat_stay_z];
_ss_end = _dropout + [0, _ss_spread, _dropout_seat_stay_z];
_seat_stay_core = norm(_ss_end - _ss_start);
seat_stay_length = _seat_stay_core + junction_socket_depth/2 + junction_socket_depth;

// Top tube length calculated later after socket positions are defined

// --- SECTION COUNTS (to fit build volume) ---
down_tube_sections = ceil(down_tube_length / max_section_length);
seat_tube_sections = 3;  // Explicitly 3 sections to accommodate mid-junction
chainstay_sections = ceil(chainstay_actual_length / max_section_length);
seat_stay_sections = ceil(seat_stay_length / max_section_length);
// top_tube_sections calculated later after top_tube_length is defined

// --- DERIVED SECTION LENGTHS ---
down_tube_section_length = down_tube_length / down_tube_sections;
seat_tube_section_length = seat_tube_length / seat_tube_sections;
chainstay_section_length = chainstay_actual_length / chainstay_sections;
seat_stay_section_length = seat_stay_length / seat_stay_sections;
// top_tube_section_length calculated later after top_tube_length is defined

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
// KEY FRAME POINTS (for positioning)
// =============================================================================
// BB center at origin
bb = [0, 0, 0];
ht_top = [reach, 0, stack];
ht_bottom = [ht_bottom_x, 0, ht_bottom_z];
st_top = _st_top;
dropout = _dropout;

// Tube connection points around BB shell
bb_down_tube = _bb_down_tube_offset;
bb_seat_tube = _bb_seat_tube_offset;
bb_chainstay_z = _bb_chainstay_z;

// Tube connection points at head tube
ht_down_tube = _ht_down_tube;
// ht_top_tube and debug steps exported after calculations below

// Tube connection points at seat tube
st_seat_stay_z = _st_seat_stay_z;
// st_top_tube exported later after calculation

// Tube connection points at dropout
dropout_chainstay_z = _dropout_chainstay_z;
dropout_seat_stay_z = _dropout_seat_stay_z;

// Tube spreads (lateral offsets)
cs_spread = _cs_spread;
ss_spread = _ss_spread;

// Lug dimensions
lug_height = 100;             // Height along head tube (increased for top tube clearance)

extension_thickness = 6;     // Wall thickness around extensions
wall_thickness = 4;

extension_depth = 90;          // How far it extends for down tube socket
extension_socket_depth = 40;           // How deep down tube inserts

_ht_vec = ht_top - ht_bottom;
_dt_vec = bb_down_tube - ht_down_tube;
_ht_dot_dt = _ht_vec[0]*_dt_vec[0] + _ht_vec[1]*_dt_vec[1] + _ht_vec[2]*_dt_vec[2];
dt_angle = acos(_ht_dot_dt / (norm(_ht_vec) * norm(_dt_vec)));

ht_unit = _ht_vec / norm(_ht_vec);
dt_unit = _dt_vec / norm(_dt_vec);

// Top tube direction: rotate head tube direction by tt_angle around global Y-axis
tt_unit = [
    ht_unit[0] * cos(tt_angle) - ht_unit[2] * sin(tt_angle),
    ht_unit[1],
    ht_unit[0] * sin(tt_angle) + ht_unit[2] * cos(tt_angle)
];

// Down tube dimensions
down_tube_extension_outer_radius = down_tube_od / 2 + extension_thickness;
down_tube_extension_translation = 40;

extension_body_depth = extension_depth - extension_socket_depth;

// Head tube dimensions
lug_outer_radius = head_tube_od / 2 + wall_thickness;
lug_collar_radius = lug_outer_radius;
top_extension_outer_radius = top_tube_od / 2 + extension_thickness;
socket_offset = lug_collar_radius - top_extension_outer_radius;
alpha = 180 - tt_angle;
x = lug_outer_radius;
y = top_extension_outer_radius;
top_extension_offset = sin(alpha)*y-(x-cos(alpha)*y)/tan(alpha);
top_extension_translation = lug_height - top_extension_offset - down_tube_extension_translation;

// Build up socket position step by step for debugging
_tt_step1 = _ht_down_tube;
_tt_step2 = _tt_step1 - dt_unit * extension_depth;
_tt_step3 = _tt_step2 + ht_unit * top_extension_translation;
_tt_step4 = _tt_step3 + tt_unit * extension_depth;
lug_tt_socket_position = _tt_step4;

// Seat tube mid-junction socket position
// Project from lug socket along tt_unit to seat tube centerline
// Seat tube runs from bb_seat_tube to st_top
_seat_tube_unit = (_st_top - _bb_seat_tube_offset) / norm(_st_top - _bb_seat_tube_offset);

// Find intersection: lug_tt_socket_position + t*tt_unit = bb_seat_tube + s*seat_tube_unit
// This is a line-line closest approach problem in 3D
_st_vec = _st_top - _bb_seat_tube_offset;
_st_unit = _st_vec / norm(_st_vec);
_w0 = _bb_seat_tube_offset - lug_tt_socket_position;
_a = _st_unit * _st_unit;  // = 1 (unit vector)
_b = _st_unit * tt_unit;   // dot product
_c = tt_unit * tt_unit;    // = 1 (unit vector)
_d = _st_unit * _w0;       // dot product
_e = tt_unit * _w0;        // dot product
_t_intersection = (_b * _e - _c * _d) / (_a * _c - _b * _b);
// Point on seat tube axis where top tube ray intersects
_st_intersection_point = _bb_seat_tube_offset + _st_unit * _t_intersection;
// Back up by extension offset along -tt_unit to place junction socket entrance
seat_tube_mid_junction_position = _st_intersection_point - tt_unit * (extension_depth - extension_socket_depth);

// Top tube length from socket to socket
top_tube_length = norm(seat_tube_mid_junction_position - lug_tt_socket_position) + extension_socket_depth;

// Top tube sections
top_tube_sections = ceil(top_tube_length / max_section_length);
top_tube_section_length = top_tube_length / top_tube_sections;

// Seat tube mid-junction orientation angles
// Socket should point toward lug (opposite of tt_unit)
_tt_inv = -tt_unit;
stmj_socket_rotation_y = atan2(_tt_inv[0], _tt_inv[2]);  // Rotation around Y axis
stmj_socket_rotation_x = atan2(_tt_inv[1], sqrt(_tt_inv[0]*_tt_inv[0] + _tt_inv[2]*_tt_inv[2]));  // Rotation around X axis

// Export for assembly (after calculations)
ht_top_tube = lug_tt_socket_position;  // Top tube socket position in lug
st_top_tube = seat_tube_mid_junction_position;  // Seat tube mid-junction socket position

// Seat tube mid-junction bolt positioning
// Calculate global position of sleeve bolt, then project onto seat tube axis
_st_mid_junction_bolt_global = seat_tube_mid_junction_position + tt_unit * (extension_depth - extension_socket_depth);
_st_vec_for_projection = st_top - bb_seat_tube;
_st_unit_for_projection = _st_vec_for_projection / norm(_st_vec_for_projection);
_st_bolt_offset_vec = _st_mid_junction_bolt_global - bb_seat_tube;
st_mid_junction_bolt_distance = _st_bolt_offset_vec * _st_unit_for_projection;  // Distance along seat tube from bb_seat_tube

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
