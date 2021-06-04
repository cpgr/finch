/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#include "FVMassTimeDerivative.h"

registerADMooseObject("finchApp", FVMassTimeDerivative);

InputParameters
FVMassTimeDerivative::validParams()
{
  InputParameters params = FVTimeKernel::validParams();
  params.addRequiredCoupledVar("saturation_w", "The wetting phase saturation");
  params.addParam<bool>("nw_phase", "false", "Whether phase is non-wetting phase");
  return params;
}

FVMassTimeDerivative::FVMassTimeDerivative(const InputParameters & parameters)
  : FVTimeKernel(parameters),
    _nwphase(getParam<bool>("nw_phase")),
    _ext(_nwphase ? "_nw" : "_w"),
    _porosity(getMaterialProperty<Real>("porosity")),
    _density(getADMaterialProperty<Real>("density" + _ext)),
    _sw_dot(adCoupledDot("saturation_w"))
{
}

ADReal
FVMassTimeDerivative::computeQpResidual()
{
  if (_nwphase)
    return -_porosity[_qp] * _density[_qp] * _sw_dot[_qp];
  else
    return _porosity[_qp] * _density[_qp] * _sw_dot[_qp];
}
