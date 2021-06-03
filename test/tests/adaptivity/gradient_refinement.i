# Test that the FVGradientIndicator indicator and ValueJumpMarker correctly
# compute the gradient between elements, and refine those elements when it is
# greater than 'refine'

[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 20
  xmax = 20
[]

[Adaptivity]
  marker = marker
  max_h_level = 4
  [Indicators]
    [indicator]
      type = FVGradientIndicator
      variable = u
    []
  []
  [Markers]
    [marker]
      type = ValueJumpMarker
      indicator = indicator
      refine = 0.1
    []
  []
[]

[Variables]
  [./u]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  [../]
[]

[FVKernels]
  [time]
    type = FVTimeKernel
     variable = u
     []
  [./diff]
    type = FVDiffusion
    variable = u
    coeff = 0.1
  [../]
[]

[Problem]
  kernel_coverage_check = off
[]

[ICs]
  [u]
    type = FunctionIC
    variable = u
    function = 'if(x<10, 1, 0)'
  []
[]

[Executioner]
  type = Transient
  end_time = 5
  dt = 1
  solve_type = NEWTON
[]

[Postprocessors]
  [numelems]
    type = NumElems
    execute_on = 'initial timestep_end'
  []
[]

[Outputs]
  exodus = true
  perf_graph = true
  execute_on = final
[]
