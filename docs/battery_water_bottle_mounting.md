# Battery and Water Bottle Mounting System

## Overview

The downtube section 1 features an integrated rivnut-based mounting system for:
- **Varstrom 52V 20Ah shark pack battery** (368×95×125mm, 1040Wh)
- **Standard water bottle cage** (74mm spacing)

Both can be mounted simultaneously on the same downtube section.

The Varstrom battery includes its own mounting bracket that bolts directly to the frame's rivnuts - no custom bracket fabrication required.

## Design Philosophy

### Rivnut Integration
- **M5 aluminum blind rivnuts** embedded directly in carbon fiber tube wall
- **4 total rivnuts** in downtube section 1
- Standard water bottle cage mounting pattern (74mm vertical spacing)
- Compatible with any standard cage or Varstrom battery bracket

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

**Battery Mount (2 rivnuts at -90° rotation - bottom of tube):**
- Lower hole: Z = 80mm from section start
- Upper hole: Z = 154mm (80 + 74mm spacing)

**Water Bottle Mount (2 rivnuts at +90° rotation - top of tube):**
- Lower hole: Z = 80mm from section start (same as battery)
- Upper hole: Z = 154mm (80 + 74mm spacing, same as battery)

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

### 4. Install Battery Mounting Bracket
**Included with Varstrom battery**

**Mounting:**
1. Position Varstrom mounting bracket against downtube bottom
2. Align bracket holes with rivnuts at -90° position (74mm spacing)
3. Insert M5 × 12mm socket head cap screws (typically included with battery)
4. Tighten to secure bracket to tube (3-4 Nm torque)

**Battery attachment:**
- Slide battery into Varstrom mounting bracket
- Lock battery in place with included battery lock
- Quick release design allows easy removal for charging
- Secures 5.0kg battery with distributed load across two mounting points

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
- M5 × 0.8mm aluminum blind rivnuts: 4 pcs (2 for battery, 2 for water bottle)

**Battery Mount Hardware:**
- Varstrom 52V 20Ah battery: 1 pc
- Varstrom battery mounting bracket: 1 pc (included with battery)
- M5 × 12mm socket head cap screws: 2 pcs (typically included with battery)

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

### Makefile
- Removed battery_mount from metal components
- Total component count: 28 STL files (19 metal + 9 plastic-cf)

## Compatibility

### Battery Compatibility
- **Primary:** Varstrom 52V 20Ah (1040Wh) - includes mounting bracket
- **Alternatives:** Any shark pack battery with standard 74mm water bottle cage mounting
- **Weight capacity:** Rivnuts rated for 5kg+ battery weight with safety margin

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
- Check battery lock is engaged before each ride
- Ensure battery doesn't rattle in mounting bracket
- Verify mounting bracket bolts are tight

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
- **Cause:** Loose battery lock or bracket bolts
- **Fix:** Ensure battery lock is fully engaged, tighten bracket mounting bolts

### Cage Loosens
- **Cause:** Vibration backing out bolts
- **Fix:** Use thread locker (blue Loctite) on bolts

---

*Document Version: 1.0*
*Last Updated: 2025-11-26*
