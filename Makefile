# OpenSCAD STL Generation Makefile

# OpenSCAD executable (adjust path if needed)
OPENSCAD := /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
# OPENSCAD := openscad

# OpenSCAD flags (Manifold is default in 2024+)
OPENSCAD_FLAGS := --backend=Manifold

# Blender executable
BLENDER := blender

# Directories
SCAD_DIR := scad
COMPONENTS_DIR := $(SCAD_DIR)/components
STL_DIR := stl
CONFIG := $(SCAD_DIR)/config.scad

# =============================================================================
# Metal Components (single parts)
# =============================================================================
METAL_SINGLE := dropout bb_shell head_tube seat_collar motor_mount \
                brake_mount cable_guide gusset_plate rack_mount \
                down_tube_gusset bb_junction head_tube_lug seat_tube_junction \
                seat_tube_mid_junction

METAL_SINGLE_STL := $(patsubst %,$(STL_DIR)/metal/%.stl,$(METAL_SINGLE))

# Dropout junctions (left and right)
DROPOUT_JUNCTION_STL := $(STL_DIR)/metal/dropout_junction_left.stl \
                        $(STL_DIR)/metal/dropout_junction_right.stl

# Tube sleeves (for all straight tubes)
SLEEVE_STL := $(STL_DIR)/metal/sleeve_down_tube.stl \
              $(STL_DIR)/metal/sleeve_seat_tube.stl \
              $(STL_DIR)/metal/sleeve_top_tube.stl \
              $(STL_DIR)/metal/sleeve_chainstay.stl \
              $(STL_DIR)/metal/sleeve_seat_stay.stl

METAL_STL := $(METAL_SINGLE_STL) $(DROPOUT_JUNCTION_STL) $(SLEEVE_STL)

# =============================================================================
# Accessories (optional components)
# =============================================================================
# None currently - battery and water bottle mount directly to rivnuts

# =============================================================================
# Plastic-CF Components (sectioned tubes)
# =============================================================================
# Down tube: 3 sections
DOWN_TUBE_STL := $(STL_DIR)/plastic-cf/down_tube_0.stl \
                 $(STL_DIR)/plastic-cf/down_tube_1.stl \
                 $(STL_DIR)/plastic-cf/down_tube_2.stl

# Seat tube: 2 sections
SEAT_TUBE_STL := $(STL_DIR)/plastic-cf/seat_tube_0.stl \
                 $(STL_DIR)/plastic-cf/seat_tube_1.stl

# Chainstays: 2 sections each, need 2 (left/right)
CHAINSTAY_STL := $(STL_DIR)/plastic-cf/chainstay_0.stl \
                 $(STL_DIR)/plastic-cf/chainstay_1.stl

# Seat stays: 2 sections each, need 2 (left/right)
SEAT_STAY_STL := $(STL_DIR)/plastic-cf/seat_stay_0.stl \
                 $(STL_DIR)/plastic-cf/seat_stay_1.stl

# Top tube: variable sections (calculated in config.scad)
# Will be 1-2 sections depending on length
TOP_TUBE_STL := $(STL_DIR)/plastic-cf/top_tube_0.stl \
                $(STL_DIR)/plastic-cf/top_tube_1.stl

PLASTIC_STL := $(DOWN_TUBE_STL) $(SEAT_TUBE_STL) $(TOP_TUBE_STL) $(CHAINSTAY_STL) $(SEAT_STAY_STL)

# =============================================================================
# Assembly (complete frame)
# =============================================================================
ASSEMBLY_STL := $(STL_DIR)/assembly.stl

# =============================================================================
# All targets
# =============================================================================
ALL_STL := $(METAL_STL) $(PLASTIC_STL)

# Default target
all: $(ALL_STL)

# Assembly target (not built by default - use 'make assembly')
assembly: $(ASSEMBLY_STL)

$(STL_DIR)/assembly.stl: $(SCAD_DIR)/assembly.scad $(CONFIG) $(wildcard $(COMPONENTS_DIR)/*/*.scad) | $(STL_DIR)
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ $<

$(STL_DIR):
	mkdir -p $@

# Create output directories
$(STL_DIR)/metal:
	mkdir -p $@

$(STL_DIR)/plastic-cf:
	mkdir -p $@

# =============================================================================
# Metal component rules
# =============================================================================
# Single metal components
$(STL_DIR)/metal/%.stl: $(COMPONENTS_DIR)/metal/%.scad $(CONFIG) | $(STL_DIR)/metal
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ $<

# Dropout junctions (left and right)
$(STL_DIR)/metal/dropout_junction_left.stl: $(COMPONENTS_DIR)/metal/dropout_junction.scad $(CONFIG) | $(STL_DIR)/metal
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -D 'render_side=-1' $<

$(STL_DIR)/metal/dropout_junction_right.stl: $(COMPONENTS_DIR)/metal/dropout_junction.scad $(CONFIG) | $(STL_DIR)/metal
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -D 'render_side=1' $<

# Tube sleeves (all straight tubes)
$(STL_DIR)/metal/sleeve_down_tube.stl: $(COMPONENTS_DIR)/metal/tube_sleeve.scad $(CONFIG) | $(STL_DIR)/metal
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -D 'render_type="down_tube"' $<

$(STL_DIR)/metal/sleeve_seat_tube.stl: $(COMPONENTS_DIR)/metal/tube_sleeve.scad $(CONFIG) | $(STL_DIR)/metal
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -D 'render_type="seat_tube"' $<

$(STL_DIR)/metal/sleeve_chainstay.stl: $(COMPONENTS_DIR)/metal/tube_sleeve.scad $(CONFIG) | $(STL_DIR)/metal
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -D 'render_type="chainstay"' $<

$(STL_DIR)/metal/sleeve_seat_stay.stl: $(COMPONENTS_DIR)/metal/tube_sleeve.scad $(CONFIG) | $(STL_DIR)/metal
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -D 'render_type="seat_stay"' $<

$(STL_DIR)/metal/sleeve_top_tube.stl: $(COMPONENTS_DIR)/metal/tube_sleeve.scad $(CONFIG) | $(STL_DIR)/metal
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -D 'render_type="top_tube"' $<

# =============================================================================
# Plastic-CF component rules (sectioned)
# =============================================================================
# Down tube sections
$(STL_DIR)/plastic-cf/down_tube_%.stl: $(COMPONENTS_DIR)/plastic-cf/down_tube.scad $(CONFIG) | $(STL_DIR)/plastic-cf
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -D 'render_section=$*' $<

# Seat tube sections
$(STL_DIR)/plastic-cf/seat_tube_%.stl: $(COMPONENTS_DIR)/plastic-cf/seat_tube.scad $(CONFIG) | $(STL_DIR)/plastic-cf
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -D 'render_section=$*' $<

# Top tube sections
$(STL_DIR)/plastic-cf/top_tube_%.stl: $(COMPONENTS_DIR)/plastic-cf/top_tube.scad $(CONFIG) | $(STL_DIR)/plastic-cf
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -D 'render_section=$*' $<

# Chainstay sections
$(STL_DIR)/plastic-cf/chainstay_%.stl: $(COMPONENTS_DIR)/plastic-cf/chainstay.scad $(CONFIG) | $(STL_DIR)/plastic-cf
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -D 'render_section=$*' $<

# Seat stay sections
$(STL_DIR)/plastic-cf/seat_stay_%.stl: $(COMPONENTS_DIR)/plastic-cf/seat_stay.scad $(CONFIG) | $(STL_DIR)/plastic-cf
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ -D 'render_section=$*' $<

# =============================================================================
# Assembly rendering for visual verification
# =============================================================================
IMG_DIR := img
ASSEMBLY_VIEWS := $(IMG_DIR)/assembly_full.png \
                  $(IMG_DIR)/bb_junction.png \
                  $(IMG_DIR)/seat_tube_junction.png \
                  $(IMG_DIR)/dropout_junction.png

# Render all assembly views
render: $(ASSEMBLY_VIEWS)

$(IMG_DIR):
	mkdir -p $@

# Full frame isometric view
$(IMG_DIR)/assembly_full.png: $(ASSEMBLY_STL) render_stl.py | $(IMG_DIR)
	$(BLENDER) -b -P render_stl.py -- $< $@ full

# BB Junction closeup (centered at origin)
$(IMG_DIR)/bb_junction.png: $(ASSEMBLY_STL) render_stl.py | $(IMG_DIR)
	$(BLENDER) -b -P render_stl.py -- $< $@ bb

# Seat Tube Junction closeup (st_top ~= [-227, 0, 481])
$(IMG_DIR)/seat_tube_junction.png: $(ASSEMBLY_STL) render_stl.py | $(IMG_DIR)
	$(BLENDER) -b -P render_stl.py -- $< $@ seat_tube

# Dropout Junction closeup (dropout ~= [-426, 0, -65])
$(IMG_DIR)/dropout_junction.png: $(ASSEMBLY_STL) render_stl.py | $(IMG_DIR)
	$(BLENDER) -b -P render_stl.py -- $< $@ dropout

# =============================================================================
# Utility targets
# =============================================================================
clean:
	rm -rf $(STL_DIR) $(IMG_DIR)

list:
	@echo "=== Metal Components ($(words $(METAL_STL)) parts) ==="
	@echo "$(METAL_STL)" | tr ' ' '\n' | sed 's|^|  |'
	@echo ""
	@echo "=== Plastic-CF Components ($(words $(PLASTIC_STL)) parts) ==="
	@echo "$(PLASTIC_STL)" | tr ' ' '\n' | sed 's|^|  |'
	@echo ""
	@echo "Total: $(words $(ALL_STL)) STL files"
	@echo ""
	@echo "=== Assembly (use 'make assembly') ==="
	@echo "  $(ASSEMBLY_STL)"

.PHONY: all clean list assembly render
