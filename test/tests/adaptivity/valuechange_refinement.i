# Test that the FVGradientIndicator indicator and ValueJumpMarker correctly
# compute the gradient between elements, and refine those elements

[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0
    xmax = 1
    nx = 20
  []
[]

[Adaptivity]
  marker = marker
  max_h_level = 2
  [Markers]
    [marker]
      type = ValueChangeMarker
      variable = snw
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
  [p_right]
    type = FVDirichletBC
    boundary = right
    variable = pw
    value = 1e6
  []
  [snw_right]
    type = FVDarcyOutflowBC
    variable = sw
    boundary = right
    pressure_w = pw
    nw_phase = true
  []
[]

[FVKernels]
  [advection_w]
    type = FVAdvectiveFlux
    variable = pw
    nw_phase = false
    pressure_w = pw
    saturation_w = sw
    gravity = '0 0 0'
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
    gravity = '0 0 0'
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
    type = CapillaryPressureBC
    saturation_w = sw
    lambda = 2
    pe = 0
    pc_max = 0
  []
  [relperm]
    type = RelPermBC
    nw_coeff = 4
    w_coeff = 4
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
  end_time = 2e4
  dtmax = 500
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    growth_factor = 2
  []
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

[Outputs]
  perf_graph = true
  exodus = true
  execute_on = FINAL
[]
