# Core mesh created using MeshGenerators
#
# Core diameter: 0.06 m
# Core length: 0.3 m
#
# To generate mesh, run finch-opt -i 3Dcoreflood_mesh.i

[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 30
    ny = 30
    nz = 150
    xmin = 0
    xmax = 0.06
    ymin = 0
    ymax = 0.06
    zmin = 0
    zmax = 0.3
  []
  [ids]
    type = ParsedSubdomainMeshGenerator
    input = mesh
    combinatorial_geometry = '(0.03-x)^2 + (0.03-y)^2<0.03^2'
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
    type = PiecewiseMultilinear
    data_file = '../data/3D_porosity_griddeddata.dat'
  []
  [perm]
    type = PiecewiseMultilinear
    data_file = '../data/3D_perm_griddeddata.dat'
  []
  [pe]
    type = PiecewiseMultilinear
    data_file = '../data/3D_pe_griddeddata.dat'
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
  file_base = '3Dcoreflood_mesh'
[]
