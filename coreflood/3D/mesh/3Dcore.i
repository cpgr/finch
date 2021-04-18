# Core flooding simulation
# 3D model of nitrogen drainage in water-saturated core
#
# Core mesh: 15 * 15 * 148 6mm hex elements
# Dimensions: 90mm * 90mm * 888mm
#
# To generate mesh, run finch-opt -i 3Dcore.i

[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 15
    ny = 15
    nz = 148
    xmin = 0
    xmax = 0.09
    ymin = 0
    ymax = 0.09
    zmin = 0
    zmax = 0.888
  []
  [ids]
    type = ParsedSubdomainMeshGenerator
    input = mesh
    combinatorial_geometry = '(0.045-x)^2 + (0.045-y)^2<0.045^2'
    block_id = 1
  []
  [delete]
    type = BlockDeletionGenerator
    input = ids
    block = 0
  []
  [core]
    type = RenameBlockGenerator
    input = delete
    old_block_id = 1
    new_block_id = 0
  []
  [boundaries]
    type = RenameBoundaryGenerator
    input = core
    old_boundary = 'bottom top front back'
    new_boundary = 'front back bottom top'
  []
[]

[AuxVariables]
  [poro]
    family = MONOMIAL
    order = CONSTANT
  []
  [perm]
    family = MONOMIAL
    order = CONSTANT
  []
  [pe]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [poro]
    type = FunctionAux
    variable = poro
    function = poro
    execute_on = 'initial'
  []
  [perm]
    type = FunctionAux
    variable = perm
    function = perm
    execute_on = 'initial'
  []
  [pe]
    type = FunctionAux
    variable = pe
    function = pe
    execute_on = 'initial'
  []
[]

[Functions]
  [poro]
    type = PiecewiseMulticonstant
    data_file = '../data/porosity_griddeddata.dat'
    direction = 'right right right'
  []
  [perm]
    type = PiecewiseMulticonstant
    data_file = '../data/perm_griddeddata.dat'
    direction = 'right right right'
  []
  [pe]
    type = PiecewiseMulticonstant
    data_file = '../data/pe_griddeddata.dat'
    direction = 'right right right'
  []
[]

[Problem]
  kernel_coverage_check = false
  solve = false
[]

[Executioner]
  type = Steady
[]

[Outputs]
  exodus = true
  file_base = '3Dcore_mesh'
[]
