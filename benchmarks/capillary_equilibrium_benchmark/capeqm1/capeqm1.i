# Capillary equilibrium case 1
# k1/k2 = 1
# Pe1/Pe2 = 1
#
# Note: Analytical solutions use the legacy form of BC relperm for nw phase

[Mesh]
  [left_mesh]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = -1
    xmax = 0
    nx = 50
    bias_x = 0.98
  []
  [right_mesh]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0
    xmax = 1
    nx = 50
    bias_x = 1.02
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

[Adaptivity]
  initial_marker = marker
  initial_steps = 2
  marker = marker
  max_h_level = 2
  [Indicators]
    [ind]
      type = FVGradientIndicator
      variable = sw
    []
  []
  [Markers]
    [marker]
      type = ValueJumpMarker
      indicator = ind
      refine = 0.3
      coarsen = 0.15
    []
  []
[]

[Problem]
  kernel_coverage_check = off
[]

[AuxVariables]
  [pc]
    family = MONOMIAL
    order = CONSTANT
  []
  [krw]
    family = MONOMIAL
    order = CONSTANT
  []
  [krnw]
    family = MONOMIAL
    order = CONSTANT
  []
  [snw]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [pc]
    type = ADMaterialRealAux
    variable = pc
    property = pc
    execute_on = 'initial timestep_end'
  []
  [krw]
    type = ADMaterialRealAux
    variable = krw
    property = relperm_w
    execute_on = 'initial timestep_end'
  []
  [krnw]
    type = ADMaterialRealAux
    variable = krnw
    property = relperm_nw
    execute_on = 'initial timestep_end'
  []
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
    scaling = 1e5
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
  end_time = 4e5
  dtmax = 20
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-4
  []
  [TimeIntegrator]
    type = BDF2
  []
  nl_abs_tol = 1e-6
  nl_max_its = 25
  nl_rel_tol = 1e-6
  l_abs_tol = 1e-8
[]

[Postprocessors]
  [numelems]
    type = NumElems
  []
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
  perf_graph = true
  interval = 10
  [csv]
    type = CSV
    sync_times = '1e4 4e4 1e5 2e5 4e5'
    sync_only = true
    time_data = true
  []
[]
