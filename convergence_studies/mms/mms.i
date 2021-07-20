# MMS solution in 1D spatial convergence study

# Variables to change for each point of convergence study
nx = 500
xmax = 1
dx = ${fparse xmax / nx}
start_point = ${fparse dx / 2}
end_point = ${fparse xmax - dx / 2}
num_points = ${fparse nx}

[Mesh]
  [mesh]
    type = GeneratedMeshGenerator
    dim = 1
    xmin = 0
    xmax = ${xmax}
    nx = ${nx}
  []
[]

[Problem]
  kernel_coverage_check = off
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

[AuxVariables]
  [krw]
    family = MONOMIAL
    order = CONSTANT
  []
  [krnw]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [krw]
    type = ADMaterialRealAux
    variable = krw
    property = relperm_w
    execute_on = 'linear'
  []
  [krnw]
    type = ADMaterialRealAux
    variable = krnw
    property = relperm_nw
    execute_on = 'linear'
  []
[]

[Debug]
  show_var_residual_norms = true
[]

[Functions]
  [sw_exact]
    type = ParsedFunction
    value = t
  []
  [pw_exact]
    type = ParsedFunction
    value = 'x^3'
  []
  [pw_force]
    type = ParsedFunction
    vars = 'phi rhow muw k krw'
    vals = '0.1 1000 1e-3 1e-13 0.5'
    value = 'phi * rhow - 6 * rhow * k * krw * x / muw'
  []
  [sw_force]
    type = ParsedFunction
    vars = 'phi rhonw munw k krnw'
    vals = '0.1 10 1e-4 1e-13 0.5'
    value = '-phi * rhonw - 6 * rhonw * k * krnw * x / munw'
  []
[]

[ICs]
  [pw_ic]
    type = FunctionIC
    variable = pw
    function = pw_exact
  []
  [sw_ic]
    type = FunctionIC
    variable = sw
    function = sw_exact
  []
[]

[FVBCs]
  [pw]
    type = FVFunctionDirichletBC
    boundary = 'left right'
    variable = pw
    function = pw_exact
  []
  [sw]
    type = FVFunctionDirichletBC
    boundary = 'left right'
    variable = sw
    function = sw_exact
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
    saturation_w = sw
    nw_phase = false
  []
  [force_w]
    type = FVBodyForce
    variable = pw
    function = pw_force
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
    saturation_w = sw
    nw_phase = true
  []
  [force_nw]
    type = FVBodyForce
    variable = sw
    function = sw_force
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
    porosity = 0.1
  []
  [permeability0]
    type = Permeability
    perm_xx = 1e-13
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
    nw_coeff = 1
    w_coeff = 1
    saturation_w = 0.5
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
  dt = 1
  end_time = 5
  solve_type = NEWTON
  nl_abs_tol = 1e-12
[]

[Postprocessors]
  [l2error]
    type = ElementL2Error
    variable = pw
    function = pw_exact
  []
  [dx]
    type = AverageElementSize
  []
[]

[VectorPostprocessors]
  [pw]
    type = LineValueSampler
    variable = 'pw sw'
    sort_by = x
    start_point = '${start_point} 0 0'
    end_point = '${end_point} 0 0'
    num_points = ${num_points}
  []
[]

[Outputs]
  print_linear_residuals = false
  file_base = mms_${nx}
  perf_graph = true
  csv = true
  execute_on = final
[]
