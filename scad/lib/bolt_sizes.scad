// BoltSize struct and standard bolt definitions
// Hybrid accessor pattern: indexed lists with constructor and accessor functions

// Internal indices (private)
_BOLT_TAP_RADIUS = 0;
_BOLT_CLEARANCE_RADIUS = 1;
_BOLT_COUNTERBORE_RADIUS = 2;
_BOLT_COUNTERBORE_DEPTH = 3;
_BOLT_BOSS_RADIUS = 4;
_BOLT_THROUGH_RADIUS = 5;

// Constructor
function BoltSize(tap_r, clearance_r, counterbore_r, counterbore_d, boss_r, through_r) =
    [tap_r, clearance_r, counterbore_r, counterbore_d, boss_r, through_r];

// Accessors
function bolt_tap_radius(bs) = bs[_BOLT_TAP_RADIUS];
function bolt_clearance_radius(bs) = bs[_BOLT_CLEARANCE_RADIUS];
function bolt_counterbore_radius(bs) = bs[_BOLT_COUNTERBORE_RADIUS];
function bolt_counterbore_depth(bs) = bs[_BOLT_COUNTERBORE_DEPTH];
function bolt_boss_radius(bs) = bs[_BOLT_BOSS_RADIUS];
function bolt_through_radius(bs) = bs[_BOLT_THROUGH_RADIUS];

// Standard bolt sizes
M5_BOLT = BoltSize(
    2.1,    // tap_radius (M5 tap drill 4.2mm diameter)
    2.75,   // clearance_radius (5.5mm clearance hole)
    4.25,   // counterbore_radius (8.5mm socket head)
    2.5,    // counterbore_depth
    6,      // boss_radius
    2.75    // through_radius (5.5mm in plastic)
);

M6_BOLT = BoltSize(
    2.5,    // tap_radius (M6 tap drill 5.0mm diameter)
    3.25,   // clearance_radius (6.5mm clearance hole)
    4.75,   // counterbore_radius (9.5mm socket head)
    2.5,    // counterbore_depth
    8,      // boss_radius
    3.25    // through_radius (6.5mm in plastic)
);
