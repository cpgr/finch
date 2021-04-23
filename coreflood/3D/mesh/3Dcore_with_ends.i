# Core flooding simulation
# 3D model of nitrogen drainage in water-saturated core
#
# Core mesh: 15 * 15 * 152 6mm hex elements (apart from ends)
# Dimensions: 90mm * 90mm * 905mm
#
# To generate mesh, run finch-opt -i 3Dcore_with_ends.i

[Mesh]
  [bottom0]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 15
    ny = 15
    nz = 1
    xmin = 0
    xmax = 0.09
    ymin = 0
    ymax = 0.09
    zmin = -0.001
    zmax = 0
  []
  [bottom1]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 15
    ny = 15
    nz = 1
    xmin = 0
    xmax = 0.09
    ymin = 0
    ymax = 0.09
    zmin = 0
    zmax = 0.0075
  []
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
    zmin = 0.0075
    zmax = 0.8955
  []
  [top1]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 15
    ny = 15
    nz = 1
    xmin = 0
    xmax = 0.09
    ymin = 0
    ymax = 0.09
    zmin = 0.8955
    zmax = 0.903
  []
  [top0]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 15
    ny = 15
    nz = 1
    xmin = 0
    xmax = 0.09
    ymin = 0
    ymax = 0.09
    zmin = 0.903
    zmax = 0.904
  []
  [stitch]
    type = StitchedMeshGenerator
    inputs = 'bottom0 bottom1 mesh top1 top0'
    clear_stitched_boundary_ids = true
    stitch_boundaries_pairs = 'front back; front back; front back; front back'
  []
  [ids]
    type = ParsedSubdomainMeshGenerator
    input = stitch
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
  [topcap]
    type = ParsedSubdomainMeshGenerator
    input = core
    combinatorial_geometry = 'z>0.903'
    block_id = 1
  []
  [bottomcap]
    type = ParsedSubdomainMeshGenerator
    input = topcap
    combinatorial_geometry = 'z<0'
    block_id = 1
  []
  [boundaries]
    type = RenameBoundaryGenerator
    input = bottomcap
    old_boundary = 'bottom top front back'
    new_boundary = 'back front top bottom'
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
    data_file = '../data/porosity_griddeddata_w_ends.dat'
    direction = 'right right right'
  []
  [perm]
    type = PiecewiseMulticonstant
    data_file = '../data/perm_griddeddata_w_ends.dat'
    direction = 'right right right'
  []
  [pe]
    type = PiecewiseMulticonstant
    data_file = '../data/pe_griddeddata_w_ends.dat'
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
  file_base = '3Dcore_mesh_with_ends'
[]
