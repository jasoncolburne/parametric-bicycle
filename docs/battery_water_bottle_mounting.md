# Battery and Water Bottle Mounting System

## Overview

The downtube section 1 features an integrated rivnut-based mounting system for:
- **Shark pack battery** (52V 14Ah, ~365×85×65mm)
- **Standard water bottle cage** (74mm spacing)

Both can be mounted simultaneously on the same downtube section.

## Design Philosophy

### Rivnut Integration
- **M5 aluminum blind rivnuts** embedded directly in carbon fiber tube wall
- **6 total rivnuts** in downtube section 1
- Standard water bottle cage mounting pattern (74mm vertical spacing)
- Compatible with any standard cage or battery mount

### Advantages
- ✅ Industry standard (works with all water bottle cages and shark pack batteries)
- ✅ Clean aesthetic (no external brackets or clamps)
- ✅ Lightweight (aluminum rivnuts, no heavy mounting hardware)
- ✅ Removable/replaceable (rivnuts can be re-installed if damaged)
- ✅ Modular (swap between different batteries or cages easily)

## Rivnut Specifications

**M5 Aluminum Blind Rivnuts:**
- Thread: M5 × 0.8mm pitch
- Body diameter: 8.5-9mm (requires 9mm hole)
- Grip range: 0.5-4mm (matches 3mm tube wall thickness)
- Flange diameter: ~9mm
- Body length: ~10mm
- Material: Aluminum (corrosion-resistant, lightweight)

## Mounting Hole Layout

### Downtube Section 1 Geometry
- Outer diameter: 44mm
- Wall thickness: 3mm
- Section length: ~163mm
- Material: Carbon fiber reinforced (FibreSeeker 3)

### Rivnut Positions

**Battery Mount (4 rivnuts at -90° rotation - bottom of tube):**
1. **Front bracket pair:**
   - Lower hole: Z = 30mm from section start
   - Upper hole: Z = 104mm (30 + 74mm spacing)

2. **Rear bracket pair:**
   - Lower hole: Z = 130mm from section start
   - Upper hole: Z = 204mm (130 + 74mm spacing)

**Water Bottle Mount (2 rivnuts at +90° rotation - top of tube):**
- Lower hole: Z = 70mm from section start
- Upper hole: Z = 144mm (70 + 74mm spacing)

### Rotation Reference
- **-90°** = Bottom of tube (battery side)
- **+90°** = Top of tube (water bottle side)
- Measured from positive Y-axis, looking down the tube

## Installation Process

### 1. Print Downtube Section 1
- Use FibreSeeker 3 with continuous carbon fiber
- Print standing upright (optimal layer orientation)
- 9mm rivnut holes should print clean with proper support

### 2. Prepare Rivnut Holes
- Remove any printing artifacts from 9mm holes
- Clean holes with 9mm drill bit if needed (light pass only)
- Ensure holes are perpendicular to tube surface

### 3. Install Rivnuts
**Tools required:**
- M5 rivnut installation tool (manual ~$30 or pneumatic ~$200)
- M5 × 0.8mm aluminum blind rivnuts (qty: 6)
- 9mm drill bit (for cleanup only)

**Installation steps:**
1. Insert rivnut into 9mm hole from outside
2. Thread installation tool mandrel into rivnut
3. Tighten mandrel to compress rivnut body
4. Rivnut expands behind tube wall, gripping carbon fiber
5. Back out mandrel when fully compressed
6. Test threads with M5 bolt (should thread smoothly)

**Result:**
- Front side: Small aluminum flange flush with tube surface
- Back side: Expanded rivnut body gripping inside wall
- Nothing protrudes from tube surface

### 4. Install Battery Brackets
**Quantity:** 2 brackets (front and rear)

**Fabrication options:**
- **Option 1:** CNC mill from 6mm 6061-T6 aluminum on NestWorks C500
- **Option 2:** 3D print from PA + continuous carbon fiber on FibreSeeker 3

**Mounting:**
1. Position bracket against downtube bottom
2. Align bracket holes with rivnuts (74mm spacing)
3. Insert M5 × 12mm socket head cap screws
4. Tighten to secure bracket to tube
5. Repeat for second bracket

**Battery attachment:**
- Use velcro straps through bracket strap slots
- 2 straps per bracket (4 total for battery)
- Wrap straps around battery and through slots
- Secures ~3.2kg battery with distributed load

### 5. Install Water Bottle Cage
**Standard water bottle cage** (any brand with 74mm mounting)

**Mounting:**
1. Position cage against downtube top
2. Align cage holes with rivnuts (74mm spacing)
3. Insert M5 × 12mm socket head cap screws (usually included with cage)
4. Tighten to secure cage

**Note:** No adapter needed - cages bolt directly to rivnuts

## Bill of Materials

### Per Frame

**Rivnuts:**
- M5 × 0.8mm aluminum blind rivnuts: 6 pcs

**Battery Mount Hardware:**
- M5 × 12mm socket head cap screws: 4 pcs (for 2 brackets)
- Battery mount brackets (aluminum or CF): 2 pcs
- Velcro battery straps (25mm wide × 300mm): 4 pcs

**Water Bottle Hardware:**
- M5 × 12mm socket head cap screws: 2 pcs (often included with cage)
- Standard water bottle cage: 1 pc

### Tools (One-Time Purchase)
- M5 rivnut installation tool: 1 pc (~$30-200)
- 9mm drill bit (for cleanup): 1 pc (~$5)

## Design Files

### Modified Components
- `scad/config.scad` - Added rivnut parameters
- `scad/components/plastic-cf/down_tube.scad` - Rivnut holes in section 1
- `scad/components/metal/battery_mount.scad` - Redesigned bracket for rivnuts

### New Components
- `scad/components/accessories/water_bottle_cage.scad` - Optional adapter plate

### Makefile
- Added `ACCESSORIES` section for water bottle cage
- Total component count: 30 STL files (20 metal + 9 plastic-cf + 1 accessory)

## Compatibility

### Battery Compatibility
- **Primary:** Shark pack style batteries with water bottle cage mounting
- **Alternatives:** Any battery with 74mm mounting hole spacing
- **Weight capacity:** Designed for ~3.2kg battery + safety margin

### Water Bottle Compatibility
- **Standard cages:** Any cage with 74mm vertical hole spacing
- **Size:** Fits standard 500-750ml bottles
- **Materials:** Plastic, aluminum, carbon fiber cages all compatible

## Maintenance

### Rivnut Inspection
- Check periodically for looseness (every 3-6 months)
- Tighten mounting bolts if needed
- If rivnut spins: remove and re-install new rivnut

### Battery Security
- Check velcro straps before each ride
- Replace straps if fraying or losing grip
- Ensure battery is secure and doesn't rattle

### Water Bottle Cage
- Check bolt tightness monthly
- Clean cage and mounting area periodically
- Ensure bolts don't back out from vibration

## Troubleshooting

### Rivnut Won't Thread
- **Cause:** Rivnut not fully set or damaged threads
- **Fix:** Remove rivnut, inspect hole, install new rivnut

### Bolt Strips Threads
- **Cause:** Cross-threading or over-tightening
- **Fix:** Remove rivnut, install new one, use torque wrench (3-4 Nm for M5)

### Battery Rattles
- **Cause:** Loose straps or bracket bolts
- **Fix:** Tighten bracket bolts, replace/tighten straps

### Cage Loosens
- **Cause:** Vibration backing out bolts
- **Fix:** Use thread locker (blue Loctite) on bolts

---

*Document Version: 1.0*
*Last Updated: 2025-11-26*
