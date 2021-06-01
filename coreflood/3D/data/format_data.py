#!/usr/bin/env python3

# Convert mat data to GriddedData format for MOOSE

import pandas as pd
import numpy as np

# Number of elements in each direction
nx, ny, nz = 15, 15, 148

# Range of x,y
xmin, xmax = 0.0, 0.09
ymin, ymax = 0.0, 0.09
zmin, zmax = 0.0, 0.888

# Arrays of corner coords
xcoords = np.linspace(xmin, xmax, nx+1)
ycoords = np.linspace(ymin, ymax, ny+1)
zcoords = np.linspace(zmin, zmax, nz+1)

# Read in the material data
# Porosity
pordata = pd.read_csv("./por_mat.dat", header=None, na_values=['NaN'], skipinitialspace=True)
pordata = pordata.values.reshape(nz, ny, nx)

# Permeability
permdata = pd.read_csv("./perm_mat.dat", header=None, na_values=['NaN'], skipinitialspace=True)
permdata = permdata.values.reshape(nz, ny, nx)

# Pe
pedata = pd.read_csv("./pe_mat.dat", header=None, na_values=['NaN'], skipinitialspace=True)
pedata = pedata.values.reshape(nz, ny, nx)

# Convert to SI units
permdata = permdata * 9.869233e-16 #md to m^2
pedata = pedata * 1e3 #kPa to Pa

# Write porosity data to MOOSE GriddedData format
with open('porosity_griddeddata.dat', 'w') as f:
    # Header
    f.write('# Core porosity field\n\n')

    # x axix
    f.write('AXIS X\n')
    for x in xcoords:
        f.write('{:.4f}'.format(x) + ' ')
    f.write('\n\n')
    f.write('AXIS Y\n')
    for y in ycoords:
        f.write('{:.4f}'.format(y) + ' ')
    f.write('\n\n')
    f.write('AXIS Z\n')
    for z in zcoords:
        f.write('{:.4f}'.format(z) + ' ')
    f.write('\n\n')
    # porosity
    f.write('DATA\n')
    for p in np.pad(pordata, (1,0), 'edge').flatten():
        f.write('{:.6f}'.format(p) + ' ')
    f.write('\n\n')

# Write permeability data to MOOSE GriddedData format
with open('perm_griddeddata.dat', 'w') as f:
    # Header
    f.write('# Core permeability field\n\n')

    # x axix
    f.write('AXIS X\n')
    for x in xcoords:
        f.write('{:.4f}'.format(x) + ' ')
    f.write('\n\n')
    f.write('AXIS Y\n')
    for y in ycoords:
        f.write('{:.4f}'.format(y) + ' ')
    f.write('\n\n')
    f.write('AXIS Z\n')
    for z in zcoords:
        f.write('{:.4f}'.format(z) + ' ')
    f.write('\n\n')
    # permeability
    f.write('DATA\n')
    for p in np.pad(permdata, (1,0), 'edge').flatten():
        f.write('{:.6e}'.format(p) + ' ')
    f.write('\n\n')

# Write entry pressure data to MOOSE GriddedData format
with open('pe_griddeddata.dat', 'w') as f:
    # Header
    f.write('# Core entry pressure field\n\n')

    # x axix
    f.write('AXIS X\n')
    for x in xcoords:
        f.write('{:.4f}'.format(x) + ' ')
    f.write('\n\n')
    f.write('AXIS Y\n')
    for y in ycoords:
        f.write('{:.4f}'.format(y) + ' ')
    f.write('\n\n')
    f.write('AXIS Z\n')
    for z in zcoords:
        f.write('{:.4f}'.format(z) + ' ')
    f.write('\n\n')
    # pe
    f.write('DATA\n')
    for p in np.pad(pedata, (1,0), 'edge').flatten():
        f.write('{:.6f}'.format(p) + ' ')
    f.write('\n\n')
