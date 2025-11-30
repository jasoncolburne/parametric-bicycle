// TubeSize struct and standard tube definitions
// Hybrid accessor pattern: indexed lists with constructor and accessor functions

include <bolt_sizes.scad>

// Fabrication constraints
fibreseeker_max_z = 245;  // FibreSeeker 3 maximum Z height in mm
max_tube_length = fibreseeker_max_z;  // Maximum printable tube length

// Internal indices (private)
_TUBE_OUTER_RADIUS = 0;
_TUBE_THICKNESS = 1;
_TUBE_INNER_SLEEVE_DEPTH = 2;
_TUBE_INNER_SLEEVE_THICKNESS = 3;
_TUBE_INNER_SLEEVE_CLEARANCE = 4;
_TUBE_SOCKET_DEPTH = 5;
_TUBE_SOCKET_CLEARANCE = 6;
_TUBE_EXTENSION_DEPTH = 7;
_TUBE_COLLAR_THICKNESS = 8;
_TUBE_PINCH_SEPARATION = 9;
_TUBE_BOLT_SIZE = 10;

// Constructor
function TubeSize(outer_r, thickness, inner_sleeve_depth, inner_sleeve_thickness, inner_sleeve_clearance, socket_depth, socket_clearance, extension_depth, collar_thickness, pinch_separation, bolt_size) =
    [outer_r, thickness, inner_sleeve_depth, inner_sleeve_thickness, inner_sleeve_clearance, socket_depth, socket_clearance, extension_depth, collar_thickness, pinch_separation, bolt_size];

// Accessors
function tube_outer_radius(ts) = ts[_TUBE_OUTER_RADIUS];
function tube_thickness(ts) = ts[_TUBE_THICKNESS];
function tube_inner_sleeve_depth(ts) = ts[_TUBE_INNER_SLEEVE_DEPTH];
function tube_inner_sleeve_thickness(ts) = ts[_TUBE_INNER_SLEEVE_THICKNESS];
function tube_inner_sleeve_clearance(ts) = ts[_TUBE_INNER_SLEEVE_CLEARANCE];
function tube_socket_depth(ts) = ts[_TUBE_SOCKET_DEPTH];
function tube_socket_clearance(ts) = ts[_TUBE_SOCKET_CLEARANCE];
function tube_extension_depth(ts) = ts[_TUBE_EXTENSION_DEPTH];
function tube_collar_thickness(ts) = ts[_TUBE_COLLAR_THICKNESS];
function tube_pinch_separation(ts) = ts[_TUBE_PINCH_SEPARATION];
function tube_bolt_size(ts) = ts[_TUBE_BOLT_SIZE];

// Standard tube sizes based on current frame design
// Standard 1-1/8" straight steerer (28.6mm OD, 25mm ID)
HEAD_TUBE = TubeSize(
    14.3,                // outer_radius (28.6mm OD - standard 1-1/8" steerer)
    1.8,                 // thickness (25mm ID)
    30,                  // inner_sleeve_depth
    3,                   // inner_sleeve_thickness
    0.25,                // inner_sleeve_clearance
    40,                  // socket_depth
    0.25,                // socket_clearance
    70,                  // extension_depth
    10,                   // collar_thickness
    1.5,                 // pinch_separation
    M5_BOLT              // bolt_size (M5 for head tube pinch)
);

// Stepped bore upper section (2mm step for seating shoulder)
HEAD_TUBE_UPPER = TubeSize(
    12.3,                    // outer_radius (24.6mm OD - 2mm step for seating)
    1.8,                     // thickness
    30,                      // inner_sleeve_depth
    3,                       // inner_sleeve_thickness
    0.25,                    // inner_sleeve_clearance
    40,                      // socket_depth
    0.25,                    // socket_clearance
    70,                      // extension_depth
    6,                       // collar_thickness
    1.5,                     // pinch_separation
    M5_BOLT                  // bolt_size
);

DOWN_TUBE = TubeSize(
    22,     // outer_radius (44mm OD)
    3,      // thickness
    30,     // inner_sleeve_depth
    3.5,    // inner_sleeve_thickness
    0.25,   // inner_sleeve_clearance
    40,     // socket_depth
    0.25,   // socket_clearance
    90,     // extension_depth
    6,      // collar_thickness
    1.5,    // pinch_separation
    M6_BOLT // bolt_size
);

SEAT_TUBE = TubeSize(
    17,     // outer_radius (34mm OD)
    3.4,    // thickness (ID = 27.2mm for seatpost)
    30,     // inner_sleeve_depth
    3,      // inner_sleeve_thickness
    0.25,   // inner_sleeve_clearance
    40,     // socket_depth
    0.25,   // socket_clearance
    80,     // extension_depth
    6,      // collar_thickness
    1.2,    // pinch_separation
    M6_BOLT // bolt_size
);

TOP_TUBE = TubeSize(
    16,     // outer_radius (32mm OD)
    2.5,    // thickness
    30,     // inner_sleeve_depth
    3,      // inner_sleeve_thickness
    0.25,   // inner_sleeve_clearance
    40,     // socket_depth
    0.25,   // socket_clearance
    80,     // extension_depth
    6,      // collar_thickness
    1,      // pinch_separation
    M6_BOLT // bolt_size
);

CHAINSTAY = TubeSize(
    11,     // outer_radius (22mm OD)
    2.5,    // thickness
    30,     // inner_sleeve_depth
    2.5,    // inner_sleeve_thickness
    0.25,   // inner_sleeve_clearance
    30,     // socket_depth
    0.25,   // socket_clearance
    50,     // extension_depth
    5,      // collar_thickness
    0.8,    // pinch_separation
    M5_BOLT // bolt_size (smaller bolts for chainstays)
);

SEATSTAY = TubeSize(
    8,      // outer_radius (16mm OD)
    2,      // thickness
    30,     // inner_sleeve_depth
    2,      // inner_sleeve_thickness
    0.25,   // inner_sleeve_clearance
    30,     // socket_depth
    0.25,   // socket_clearance
    50,     // extension_depth
    5,      // collar_thickness
    0.7,    // pinch_separation
    M5_BOLT // bolt_size (smaller bolts for seatstays)
);

SEAT_POST = TubeSize(
    13.6,   // outer_radius (27.2mm OD - standard seatpost)
    1.5,    // thickness (wall thickness)
    0,      // inner_sleeve_depth (N/A - seatpost doesn't section)
    0,      // inner_sleeve_thickness (N/A)
    0,      // inner_sleeve_clearance (N/A)
    0,      // socket_depth (N/A - seatpost inserts into seat tube)
    0.25,   // socket_clearance (clearance between seatpost and seat tube)
    0,      // extension_depth (N/A)
    4,      // collar_thickness (seat collar wall thickness)
    0,      // pinch_separation (N/A)
    M5_BOLT // bolt_size (seat collar uses M5)
);
