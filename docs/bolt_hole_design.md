# Bolt Hole Design for Junction Components

## Overview

This document explains how to properly design three-section bolt holes (counterbore + clearance + tap) for junction components that have tube socket cavities.

## Problem: Socket Cavity Geometry

Junction components have concave socket cavities where tubes insert. When drilling bolt holes perpendicular to these sockets:

1. **The socket is a void** - provides no material for drilling through
2. **Socket edges are concave** - holes positioned at the perimeter edge get "pushed outward" by the concave geometry
3. **Clearance holes must penetrate INTO the socket cavity** to bridge the gap between counterbore and tap hole

## Three-Section Bolt Hole Design

Each bolt hole has three sections:

### 1. Counterbore (Outer Side)
- **Purpose**: Seats the M6 socket head cap screw (10mm head, 6mm height)
- **Diameter**: 10mm (`m6_socket_head_diameter`)
- **Depth**: 30mm (extends through hull and into/past socket cavity)
- **Position**: Starts 3mm beyond tube bore edge to provide mounting surface
- **Formula**: `translate([0, 0, side * ((tube_od + socket_clearance)/2 + 3)])`

### 2. Clearance Hole (Middle Section)
- **Purpose**: Provides passage for smooth M6 bolt shaft (6mm) to pass through socket cavity
- **Diameter**: 6.5mm (`joint_bolt_diameter + 0.5`)
- **Depth**: 8mm (bridges from inside socket cavity to counterbore)
- **Position**: Starts INSIDE socket cavity (5mm inward from tube bore edge)
- **Formula**: `translate([0, 0, side * ((tube_od + socket_clearance)/2 - 5)])`
- **Critical**: Must start inside the cavity, not at the edge, to avoid being pushed outward by concave geometry

### 3. Tap Hole (Inner Side)
- **Purpose**: Provides threaded engagement for M6 x 1.0 threads (no nut needed)
- **Diameter**: 5.0mm (`m6_tap_drill` - tap drill for M6 x 1.0 in aluminum)
- **Depth**: 8mm (adequate thread engagement in aluminum)
- **Position**: Starts at tube bore edge on OPPOSITE side from counterbore
- **Formula**:
  - Standard orientation: `translate([0, 0, -side * (tube_od + socket_clearance)/2])`
  - 180° rotated orientation: Same formula (flip occurs automatically with rotation)

## Orientation and Side Parameter

The `side` parameter (±1) determines which side of the junction (left/right):
- `side = 1`: Right side
- `side = -1`: Left side

### Standard Orientation: `rotate([90, 0, 0])`
- Counterbore: `+side` direction (outward from junction)
- Clearance: `+side` direction (from inside cavity outward)
- Tap hole: `-side` direction (inward toward junction)

### 180° Rotated Orientation: `rotate([90, 0, 180])`
Use when bolt needs to enter from opposite direction.
- Counterbore: `+side` direction (rotation flips which surface this is)
- Clearance: `+side` direction (same as counterbore side)
- Tap hole: `-side` direction (opposite side gets flipped by rotation)

## Complete Example: Chainstay Bolt (180° Rotated)

```scad
orient_to(cs_end, cs_start)
    translate([0, 0, junction_socket_depth/2 - 25])
        rotate([90, 0, 180]) {
            // Counterbore for socket head cap screw (rotated 180° from seat stay)
            // Starts 3mm from tube bore, extends outward to clear entire hull
            translate([0, 0, side * ((chainstay_od + socket_clearance)/2 + 3)])
                cylinder(h = 30, d = m6_socket_head_diameter);

            // Clearance hole for bolt shaft (from inside socket cavity to counterbore)
            translate([0, 0, side * ((chainstay_od + socket_clearance)/2 - 5)])
                cylinder(h = 8, d = joint_bolt_diameter + 0.5);

            // Tap drill hole for M6 threads (starts exactly at tube bore edge)
            translate([0, 0, -side * (chainstay_od + socket_clearance)/2])
                cylinder(h = 8, d = m6_tap_drill);
        }
```

## Complete Example: Seat Stay Bolt (Standard Orientation)

```scad
orient_to(ss_end, ss_start)
    translate([0, 0, junction_socket_depth/2 - 25])
        rotate([90, 0, 0]) {
            // Counterbore for socket head cap screw
            // Starts 3mm from tube bore, extends outward to clear entire hull
            translate([0, 0, side * ((seat_stay_od + socket_clearance)/2 + 3)])
                cylinder(h = 30, d = m6_socket_head_diameter);

            // Clearance hole for bolt shaft (from inside socket cavity to counterbore)
            translate([0, 0, side * ((seat_stay_od + socket_clearance)/2 - 5)])
                cylinder(h = 8, d = joint_bolt_diameter + 0.5);

            // Tap drill hole for M6 threads (starts exactly at tube bore edge)
            translate([0, 0, -side * (seat_stay_od + socket_clearance)/2])
                cylinder(h = 8, d = m6_tap_drill);
        }
```

## Key Measurements

- **Tube bore edge**: `(tube_od + socket_clearance)/2`
- **Counterbore start**: Tube bore + 3mm outward = `(tube_od + socket_clearance)/2 + 3`
- **Clearance start**: Tube bore - 5mm inward = `(tube_od + socket_clearance)/2 - 5`
- **Tap start**: Exactly at tube bore = `(tube_od + socket_clearance)/2`

## Why This Works

1. **Counterbore extends deep (30mm)**: Reaches through hull and past socket cavity
2. **Clearance starts inside cavity (-5mm)**: Penetrates into the void, not pushed outward by concave edge
3. **Clearance extends outward (8mm)**: Bridges gap from cavity interior to where counterbore reaches
4. **Tap on opposite side**: Provides threaded engagement without interfering with counterbore/clearance path

## Common Mistakes

### ❌ Starting clearance at tube bore edge
```scad
// WRONG - gets pushed outward by concave socket geometry
translate([0, 0, side * (tube_od + socket_clearance)/2])
    cylinder(h = 3, d = joint_bolt_diameter + 0.5);
```

### ❌ Centering clearance hole
```scad
// WRONG - punches through hull on opposite side
cylinder(h = 60, d = joint_bolt_diameter + 0.5, center = true);
```

### ❌ Wrong tap position with rotation
```scad
// WRONG for 180° rotation - tap ends up on same side as counterbore
rotate([90, 0, 180]) {
    translate([0, 0, side * (tube_od + socket_clearance)/2])  // Should be -side
        cylinder(h = 8, d = m6_tap_drill);
}
```

### ✅ Correct: Start clearance inside cavity
```scad
// CORRECT - penetrates into socket cavity
translate([0, 0, side * ((tube_od + socket_clearance)/2 - 5)])
    cylinder(h = 8, d = joint_bolt_diameter + 0.5);
```

## Verification Checklist

When implementing bolt holes in junction components:

- [ ] Counterbore visible on hull exterior
- [ ] Counterbore does NOT punch through opposite side
- [ ] Clearance hole starts INSIDE socket cavity (not at edge)
- [ ] Clearance hole does NOT punch through hull exterior
- [ ] Tap hole visible on opposite side from counterbore
- [ ] Tap hole does NOT punch through hull exterior
- [ ] All three holes are aligned (share same axis through rotation/orient_to)
- [ ] Bolt can pass: counterbore (30mm) → clearance (8mm) → socket cavity → tap (8mm)

## Manufacturing Notes

### CNC Operations (NestWorks C500)
1. **Counterbore**: 10mm end mill to 30mm depth from outer side
2. **Clearance hole**: 6.5mm drill from outer side (following counterbore axis), stopping inside socket cavity
3. **Tap drill**: 5.0mm drill from inner side to 8mm depth
4. **Tap threads**: M6 x 1.0 tap from inner side to 8mm depth

### Thread Engagement
- **Material**: 6061-T6 or 7075-T6 aluminum
- **Thread depth**: 8mm provides adequate engagement for M6 bolts
- **Tap drill**: 5.0mm for M6 x 1.0 (75% thread engagement in aluminum)
- **Expected strength**: Bolt will fail before threads strip with 8mm engagement

---

*Document Version: 1.0*
*Last Updated: 2025-11-25*
