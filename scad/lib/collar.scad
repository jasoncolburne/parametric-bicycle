// Collar struct for sleeve collar configurations
// Hybrid accessor pattern: indexed lists with constructor and accessor functions

include <tube_sizes.scad>

// Internal indices (private)
_COLLAR_TUBE_SIZE = 0;
_COLLAR_ROTATION = 1;
_COLLAR_HEIGHT = 2;
_COLLAR_TRANSLATION = 3;
_COLLAR_CAP = 4;
_COLLAR_AXIS_ROTATION = 5;

// Constructor
function Collar(tube_size, rotation, height, translation = [0, 0, 0], cap = false, axis_rotation = 0) =
    [tube_size, rotation, height, translation, cap, axis_rotation];

// Accessors
function collar_tube_size(c) = c[_COLLAR_TUBE_SIZE];
function collar_rotation(c) = c[_COLLAR_ROTATION];
function collar_height(c) = c[_COLLAR_HEIGHT];
function collar_translation(c) = c[_COLLAR_TRANSLATION];
function collar_cap(c) = c[_COLLAR_CAP];
function collar_axis_rotation(c) = c[_COLLAR_AXIS_ROTATION];
