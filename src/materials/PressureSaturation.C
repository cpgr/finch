
/*****************************************************************/
/*    FINCH - FINite volume Capillary Heterogeneity modelling    */
/*                                                               */
/*           All contents are licensed under MIT/BSD             */
/*              See LICENSE for full restrictions                */
/*****************************************************************/

#include "PressureSaturation.h"

registerMooseObject("finchApp", PressureSaturation);

InputParameters
PressureSaturation::validParams()
{
  InputParameters params = Material::validParams();
  params.addRequiredCoupledVar("pressure_w", "The wetting phase pressure (Pa)");
  params.addRequiredCoupledVar("saturation_w", "The wetting phase saturation (-)");
  return params;
}

PressureSaturation::PressureSaturation(const InputParameters & parameters)
  : Material(parameters),
    _sw(declareADProperty<Real>("s_w")),
    _snw(declareADProperty<Real>("s_nw")),
    _pw(declareADProperty<Real>("p_w")),
    _pnw(declareADProperty<Real>("p_nw")),
    _pc(getADMaterialProperty<Real>("pc")),
    _pw_var(adCoupledValue("pressure_w")),
    _sw_var(adCoupledValue("saturation_w"))
{
}

void
PressureSaturation::computeQpProperties()
{
  _sw[_qp] = _sw_var[_qp];
  _snw[_qp] = 1.0 - _sw_var[_qp];
  _pw[_qp] = _pw_var[_qp];
  _pnw[_qp] = _pw_var[_qp] + _pc[_qp];
}
