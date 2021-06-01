/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#include "Fluid.h"

registerMooseObject("finchApp", Fluid);

InputParameters
Fluid::validParams()
{
  InputParameters params = Material::validParams();
  params.addRequiredParam<UserObjectName>("fp", "The name of the user object for fluid properties");
  params.addRequiredCoupledVar("pressure_w", "The wetting phase pressure (Pa)");
  params.addRequiredCoupledVar("temperature", "The temperature (K)");
  params.addParam<bool>("nw_phase", "false", "Whether phase is non-wetting phase");
  return params;
}

Fluid::Fluid(const InputParameters & parameters)
  : Material(parameters),
    _nwphase(getParam<bool>("nw_phase")),
    _ext(_nwphase ? "_nw" : "_w"),
    _density(declareADProperty<Real>("density" + _ext)),
    _viscosity(declareADProperty<Real>("viscosity" + _ext)),
    _pc(getADMaterialProperty<Real>("pc")),
    _pw(adCoupledValue("pressure_w")),
    _T(adCoupledValue("temperature")),
    _fp(getUserObject<SinglePhaseFluidProperties>("fp"))
{
}

void
Fluid::computeQpProperties()
{
  ADReal p = _pw[_qp];

  if (_nwphase)
    p += _pc[_qp];

  _density[_qp] = _fp.rho_from_p_T(p, _T[_qp]);
  _viscosity[_qp] = _fp.mu_from_p_T(p, _T[_qp]);
}
