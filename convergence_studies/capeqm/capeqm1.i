# Capillary equilibrium case 1 convergence study
# k1/k2 = 1
# Pe1/Pe2 = 1

# Change nx_half (which is the number of elements in each half segment of the mesh)
# to perform a spatial convergence study.
nx_half = 50
nx = ${fparse 2 * nx_half}

[Mesh]
  [left_mesh]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = -1
    xmax = 0
    nx = ${nx_half}
  []
  [right_mesh]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0
    xmax = 1
    nx = ${nx_half}
  []
  [stitched]
    type = StitchedMeshGenerator
    inputs = 'left_mesh right_mesh'
    stitch_boundaries_pairs = 'right left'
  []
  [blocks]
    type = SubdomainBoundingBoxGenerator
    bottom_left = '0 0 0'
    top_right = '1 1 0'
    block_id = 1
    input = stitched
  []
[]

[Problem]
  kernel_coverage_check = off
[]

[AuxVariables]
  [snw]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [snw]
    type = ADMaterialRealAux
    variable = snw
    property = s_nw
    execute_on = 'initial timestep_end'
  []
[]

[Variables]
  [pw]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
  [sw]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
[]

[Debug]
  show_var_residual_norms = true
[]

[ICs]
  [pw_ic]
    type = FunctionIC
    variable = pw
    function = 'if(x<0, 1e6, 1e6)'
  []
  [sw_ic]
    type = FunctionIC
    variable = sw
    function = 'if(x<0, 1, 0)'
  []
[]

[FVKernels]
  [advection_w]
    type = FVAdvectiveFlux
    variable = pw
    nw_phase = false
    pressure_w = pw
    saturation_w = sw
  []
  [time_w]
    type = FVMassTimeDerivative
    variable = pw
    nw_phase = false
    saturation_w = sw
  []
  [advection_nw]
    type = FVAdvectiveFlux
    variable = sw
    nw_phase = true
    pressure_w = pw
    saturation_w = sw
  []
  [time_nw]
    type = FVMassTimeDerivative
    variable = sw
    nw_phase = true
    saturation_w = sw
  []
[]

[Materials]
  [fw]
    type = ConstantFluid
    density = 1000
    viscosity = 1e-3
    nw_phase = false
  []
  [fnw]
    type = ConstantFluid
    density = 1000
    viscosity = 1e-3
    nw_phase = true
  []
  [porosity]
    type = Porosity
    porosity = 0.2
  []
  [permeability0]
    type = Permeability
    perm_xx = 1e-12
    block = 0
  []
  [permeability1]
    type = Permeability
    perm_xx = 1e-12
    block = 1
  []
  [pc0]
    type = CapillaryPressureBC
    saturation_w = sw
    lambda = 2
    pe = 3500
    pc_max = 1e4
    block = 0
  []
  [pc1]
    type = CapillaryPressureBC
    saturation_w = sw
    lambda = 2
    pe = 3500
    pc_max = 1e4
    block = 1
  []
  [relperm]
    type = RelPermBC
    nw_coeff = 2
    w_coeff = 4
    saturation_w = sw
    use_legacy_form = true
  []
  [props]
    type = PressureSaturation
    pressure_w = pw
    saturation_w = sw
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
    petsc_options_iname = '-sub_pc_type -pc_type -sub_pc_factor_shift_type'
    petsc_options_value = 'lu asm NONZERO'
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  end_time = 1e5
  dt = 20
  [TimeIntegrator]
    type = BDF2
  []
  nl_abs_tol = 1e-6
  nl_max_its = 10
  nl_rel_tol = 1e-5
  l_abs_tol = 1e-8
[]

[VectorPostprocessors]
  [snw]
    type = ElementValueSampler
    variable = snw
    sort_by = x
    execute_on = timestep_end
  []
[]

[Outputs]
  print_linear_residuals = false
  file_base = capeqm_${nx}
  perf_graph = true
  csv = true
  execute_on = final
[]
