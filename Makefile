# OpenSCAD STL Generation Makefile

# OpenSCAD executable (adjust path if needed)
OPENSCAD := /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
# OPENSCAD := openscad

# Directories
SCAD_DIR := scad
COMPONENTS_DIR := $(SCAD_DIR)/components
STL_DIR := stl
CONFIG := $(SCAD_DIR)/config.scad

# =============================================================================
# Metal Components (single parts)
# =============================================================================
METAL_SINGLE := dropout bb_shell head_tube seat_collar motor_mount \
                battery_mount brake_mount cable_guide gusset_plate rack_mount

METAL_SINGLE_STL := $(patsubst %,$(STL_DIR)/metal/%.stl,$(METAL_SINGLE))

# Tube sleeves (different sizes)
SLEEVE_STL := $(STL_DIR)/metal/sleeve_down_tube.stl \
              $(STL_DIR)/metal/sleeve_seat_tube.stl \
              $(STL_DIR)/metal/sleeve_chainstay.stl \
              $(STL_DIR)/metal/sleeve_seat_stay.stl

METAL_STL := $(METAL_SINGLE_STL) $(SLEEVE_STL)

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

PLASTIC_STL := $(DOWN_TUBE_STL) $(SEAT_TUBE_STL) $(CHAINSTAY_STL) $(SEAT_STAY_STL)

# =============================================================================
# All targets
# =============================================================================
ALL_STL := $(METAL_STL) $(PLASTIC_STL)

# Default target
all: $(ALL_STL)

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
	$(OPENSCAD) -o $@ $<

# Tube sleeves
$(STL_DIR)/metal/sleeve_down_tube.stl: $(COMPONENTS_DIR)/metal/tube_sleeve.scad $(CONFIG) | $(STL_DIR)/metal
	$(OPENSCAD) -o $@ -D 'render_type="down_tube"' $<

$(STL_DIR)/metal/sleeve_seat_tube.stl: $(COMPONENTS_DIR)/metal/tube_sleeve.scad $(CONFIG) | $(STL_DIR)/metal
	$(OPENSCAD) -o $@ -D 'render_type="seat_tube"' $<

$(STL_DIR)/metal/sleeve_chainstay.stl: $(COMPONENTS_DIR)/metal/tube_sleeve.scad $(CONFIG) | $(STL_DIR)/metal
	$(OPENSCAD) -o $@ -D 'render_type="chainstay"' $<

$(STL_DIR)/metal/sleeve_seat_stay.stl: $(COMPONENTS_DIR)/metal/tube_sleeve.scad $(CONFIG) | $(STL_DIR)/metal
	$(OPENSCAD) -o $@ -D 'render_type="seat_stay"' $<

# =============================================================================
# Plastic-CF component rules (sectioned)
# =============================================================================
# Down tube sections
$(STL_DIR)/plastic-cf/down_tube_%.stl: $(COMPONENTS_DIR)/plastic-cf/down_tube.scad $(CONFIG) | $(STL_DIR)/plastic-cf
	$(OPENSCAD) -o $@ -D 'render_section=$*' $<

# Seat tube sections
$(STL_DIR)/plastic-cf/seat_tube_%.stl: $(COMPONENTS_DIR)/plastic-cf/seat_tube.scad $(CONFIG) | $(STL_DIR)/plastic-cf
	$(OPENSCAD) -o $@ -D 'render_section=$*' $<

# Chainstay sections
$(STL_DIR)/plastic-cf/chainstay_%.stl: $(COMPONENTS_DIR)/plastic-cf/chainstay.scad $(CONFIG) | $(STL_DIR)/plastic-cf
	$(OPENSCAD) -o $@ -D 'render_section=$*' $<

# Seat stay sections
$(STL_DIR)/plastic-cf/seat_stay_%.stl: $(COMPONENTS_DIR)/plastic-cf/seat_stay.scad $(CONFIG) | $(STL_DIR)/plastic-cf
	$(OPENSCAD) -o $@ -D 'render_section=$*' $<

# =============================================================================
# Utility targets
# =============================================================================
clean:
	rm -rf $(STL_DIR)

list:
	@echo "=== Metal Components ($(words $(METAL_STL)) parts) ==="
	@echo "$(METAL_STL)" | tr ' ' '\n' | sed 's|^|  |'
	@echo ""
	@echo "=== Plastic-CF Components ($(words $(PLASTIC_STL)) parts) ==="
	@echo "$(PLASTIC_STL)" | tr ' ' '\n' | sed 's|^|  |'
	@echo ""
	@echo "Total: $(words $(ALL_STL)) STL files"

.PHONY: all clean list
