# Makefile for compiling EVA Fortran programs

# Compiler
FC = mpiifort

# NETCDF configuration
NETCDF_PREFIX := $(shell nf-config --prefix)
NETCDF_FLAGS := $(shell nf-config --cflags --fflags --flibs)

# Include and Lib directories
INCLUDES = -I$(NETCDF_PREFIX)/include

# Compilation flags
FFLAGS = $(INCLUDES) $(NETCDF_FLAGS)

# Module and object
MODULE = mo_EVA.f90
MODULE_OBJ = mo_EVA.o

# Executables and sources
EXECS = eva_build_sulfate_file \
        eva_build_forcing_files \
        eva_build_forcing_files_on_levels \
        eva_build_aod_file \
        eva_build_forcing_files_cmip6

# Derive sources from executables
SOURCES = $(addsuffix .f90, $(EXECS))

# Default rule
all: $(EXECS)

# Rule to compile module
$(MODULE_OBJ): $(MODULE)
	$(FC) -c $< $(INCLUDES)

# Rule to compile executables
%: %.f90 $(MODULE_OBJ)
	$(FC) -o $@ $< $(MODULE_OBJ) $(FFLAGS)

# Clean rule
clean:
	rm -f $(EXECS) *.o *.mod
