# Buckley-Leverett example with adaptivity

[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0
    xmax = 10
    nx = 100
  []
[]

[Adaptivity]
  marker = marker
  max_h_level = 3
  [Markers]
    [marker]
      type = ValueChangeMarker
      variable = snw
      upper_bound = 1
      lower_bound = 0.05
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
    scaling = 1e6
  []
[]

[Debug]
  show_var_residual_norms = true
[]

[ICs]
  [pw_ic]
    type = ConstantIC
    variable = pw
    value = 1e6
  []
  [sw_ic]
    type = ConstantIC
    variable = sw
    value = 1
  []
[]

[DiracKernels]
  [snw]
    type = ConstantPointSource
    point = '0 0 0'
    variable = sw
    value = 2e-5
  []
[]


[FVBCs]
  [right]
    type = FVDirichletBC
    boundary = right
    variable = pw
    value = 1e6
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
    density = 10
    viscosity = 1e-4
    nw_phase = true
  []
  [porosity]
    type = Porosity
    porosity = 0.2
  []
  [permeability0]
    type = Permeability
    perm_xx = 1e-12
  []
  [pc0]
    type = CapillaryPressureBC2
    saturation_w = sw
    lambda = 2
    pe = 0
    swirr = 0.08
    pc_max = 0
  []
  [relperm]
    type = RelPermBC2
    w_coeff = 2
    nw_coeff = 2
    krw_end = 1
    krnw_end = 0.8
    swirr = 0.08
    saturation_w = sw
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
  dtmax = 500
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.00001
    growth_factor = 2
  []
  [TimeIntegrator]
    type = BDF2
  []
  nl_abs_tol = 1e-8
  nl_max_its = 10
  nl_rel_tol = 1e-5
  l_abs_tol = 1e-12
[]

[Postprocessors]
  [numelems]
    type = NumElems
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [massw]
    type = FluidMass
    nw_phase = false
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [massnw]
    type = FluidMass
    nw_phase = true
    execute_on = 'INITIAL TIMESTEP_END'
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
    sync_times = '1e5 2e5 4e5'
    sync_only = true
    time_data = true
  []
[]
